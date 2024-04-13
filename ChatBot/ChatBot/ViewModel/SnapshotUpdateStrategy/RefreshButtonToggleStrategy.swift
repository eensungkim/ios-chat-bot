//
//  RefreshButtonToggleStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/9/24.
//

import UIKit

struct RefreshButtonToggleStrategy: SnapshotUpdateStrategy {
    func apply(
        using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>,
        with chatMessage: ChatMessage,
        loadingMessage: ChatMessage
    ) {
        var newChat = chatMessage
        newChat.toggleRefreshButton()
        
        snapshot.insertItems([newChat], beforeItem: chatMessage)
        snapshot.deleteItems([chatMessage])
    }
}
