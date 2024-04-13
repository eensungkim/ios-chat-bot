//
//  AssistantChatUpdateStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

struct AssistantChatUpdateStrategy: SnapshotUpdateStrategy {
    func apply(
        using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>,
        with chatMessage: ChatMessage,
        loadingMessage: ChatMessage
    ) {
        if let last = snapshot.itemIdentifiers.last {
            snapshot.insertItems([chatMessage], afterItem: last)
            if snapshot.itemIdentifiers.contains(loadingMessage) {
                snapshot.deleteItems([loadingMessage])                
            }
        }
    }
}
