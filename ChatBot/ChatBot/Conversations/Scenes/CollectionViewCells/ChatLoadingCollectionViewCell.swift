//
//  ChatLoadingCollectionViewCell.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

class ChatLoadingCollectionViewCell: UICollectionViewCell {
    static let className = String(describing: ChatLoadingCollectionViewCell.self)
    
    private let chatLoadingIndicator = ChatLoadingIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ChatLoadingCollectionViewCell {
    private func configureUI() {
        addSubview(chatLoadingIndicator)
        
        chatLoadingIndicator.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
}
