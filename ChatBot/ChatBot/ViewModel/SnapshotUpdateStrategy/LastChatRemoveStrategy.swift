//
//  LastChatRemoveStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/9/24.
//

import UIKit

struct LastChatRemoveStrategy: SnapshotUpdateStrategy {
    func apply(
        using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>,
        with chatMessage: ChatMessage,
        loadingMessage: ChatMessage
    ) {
        guard let last = snapshot.itemIdentifiers.last else {
            return
        }
        
        snapshot.deleteItems([last])
    }
}
