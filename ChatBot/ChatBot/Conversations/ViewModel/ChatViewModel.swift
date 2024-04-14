//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import UIKit

import RxCocoa
import RxSwift

// 채팅 뷰 모델
final class ChatViewModel {
    enum Section {
        case main
    }
    
    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>?
    private(set) lazy var snapshotPublisher = PublishRelay<[ChatMessage]>()
    private(set) var service = ChatAPIService()
    private lazy var loadingMessage = createMessage(with: "loading", role: .assistant)
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ChatMessage> {
        guard let snapshot = dataSource?.snapshot() else {
            return NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        }
        return snapshot
    }
}

// MARK: - Custom Methods
extension ChatViewModel {
    private func requestAssistantChat(with chatMessage: ChatMessage) -> any Disposable {
        let messages = snapshot.itemIdentifiers.map {
            return $0.convert()
        }
        
        return service.createChats(contents: messages)
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(
            onSuccess: { [weak self] response in
                guard let message = response?.choices[0].message.content,
                      let chatMessage = self?.createMessage(with: message, role: .assistant) else {
                    return
                }
                
                self?.applySnapShot(with: chatMessage, strategy: AssistantChatUpdateStrategy())
            }, onFailure: { [weak self] error in
                print(error)
                self?.removeLoadingIndicator()
                self?.applySnapShot(with: chatMessage, strategy: RefreshButtonToggleStrategy())
            }
        )
    }
    
    private func createMessage(with message: String, role: ChatRole) -> ChatMessage {
        return ChatMessage(
            id: UUID(),
            role: role,
            message: message,
            showRefreshButton: false
        )
    }
    
    private func createBubbleView(by role: ChatRole) -> ChatBubbleView {
        switch role {
        case .user:
            return UserChatBubbleView()
        case .system, .assistant:
            return AssistantChatBubbleView()
        }
    }
    
    private func removeLoadingIndicator() {
        applySnapShot(strategy: LoadingIndicatorRemoveStrategy())
    }
}

// MARK: - Public Methods
extension ChatViewModel {
    func setDataSource(delegate: ChatCollectionViewCellDelegate, collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            if itemIdentifier.id == self?.loadingMessage.id {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLoadingCollectionViewCell.className, for: indexPath) as? ChatLoadingCollectionViewCell else {
                    return ChatLoadingCollectionViewCell()
                }
                return cell
                
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.className, for: indexPath) as? ChatCollectionViewCell,
                      let view = self?.createBubbleView(by: itemIdentifier.role)
                else {
                    return ChatCollectionViewCell()
                }
                
                cell.setChatBubbleView(view, with: itemIdentifier, delegate: delegate)
                return cell
            }
        }
        
        setUpSnapshot()
    }
    
    func updateUserChat(with message: String) {
        let chatMessage = createMessage(with: message, role: .user)
        applySnapShot(with: chatMessage, strategy: UserChatUpdateStrategy())
        _ = requestAssistantChat(with: chatMessage)
    }
    
    func removeLastChat() {
        applySnapShot(strategy: LastChatRemoveStrategy())
    }
}

// MARK: - Snapshots
extension ChatViewModel {
    private func setUpSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapShot(
        with chatMessage: ChatMessage = ChatMessage(
            id: UUID(),
            role: .assistant,
            message: "",
            showRefreshButton: false
        ),
        strategy: SnapshotUpdateStrategy
    ) {
        var snapshot = snapshot
        strategy.apply(using: &snapshot, with: chatMessage, loadingMessage: loadingMessage)
        
        dataSource?.apply(snapshot) { [weak self] in
            guard let items = self?.snapshot.itemIdentifiers else {
                return
            }
            self?.snapshotPublisher.accept(items)
        }
    }
}
