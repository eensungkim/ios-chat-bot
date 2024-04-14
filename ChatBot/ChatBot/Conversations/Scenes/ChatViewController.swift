//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/29/24.
//

import UIKit

import RxSwift

/// 채팅 뷰 컨트롤러
final class ChatViewController: UIViewController {
    private let chatTextView = ChatTextView()
    private lazy var chatCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    
    private let chatViewModel = ChatViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpChatCollectionView()
        initializeHideKeyboard()
        registerButton()
        bindToModelForReposition()
        observeKeyboardWillShowNotification()
    }
}

// MARK: - UI
extension ChatViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(chatCollectionView)
        view.addSubview(chatTextView)
        
        chatCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(chatTextView.snp.top)
        }
        
        chatTextView.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

// MARK: - Private Methods
extension ChatViewController {
    private func registerButton() {
        chatTextView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let text = self?.chatTextView.textView.text else {
                    return
                }
                
                self?.chatViewModel.updateUserChat(with: text)
                self?.chatTextView.textView.text = ""
            })
            .disposed(by: bag)
    }
    
    private func observeKeyboardWillShowNotification() {
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                if let userInfo = notification.userInfo,
                   let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                   let animationCurveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                    
                    let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
                    self?.animateCollectionView(duration: animationDuration, curve: animationCurve)
                }
            })
            .disposed(by: bag)
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ChatCollectionView
extension ChatViewController {
    private func setUpChatCollectionView() {
        chatCollectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.className)
        chatCollectionView.register(ChatLoadingCollectionViewCell.self, forCellWithReuseIdentifier: ChatLoadingCollectionViewCell.className)
        
        chatViewModel.setDataSource(delegate: self, collectionView: chatCollectionView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func bindToModelForReposition() {
        _ = chatViewModel.snapshotPublisher.bind(onNext: { [weak self] _ in
            self?.repositionCollectionView(animated: true)
        })
        .disposed(by: bag)
    }
    
    private func repositionCollectionView(animated: Bool) {
        let index = chatCollectionView.numberOfItems(inSection: 0)
        let indexPath = IndexPath(item: index - 1, section: 0)
        chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    private func animateCollectionView(duration: TimeInterval, curve: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: curve, animations: { [weak self] in
            self?.repositionCollectionView(animated: false)
        }, completion: nil)
    }
}

// MARK: - ChatCollectionViewCellDelegate
extension ChatViewController: ChatCollectionViewCellDelegate {
    func tapRefreshButton(_ chatCollectionViewCell: ChatCollectionViewCell) {
        guard let text = chatCollectionViewCell.chatBubbleView.textLabel.text else {
            return
        }
        chatViewModel.removeLastChat()
        chatViewModel.updateUserChat(with: text)
    }
}
