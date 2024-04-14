//
//  SnapshotUpdateStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

protocol SnapshotUpdateStrategy {
    func apply(
        using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>,
        with chatMessage: ChatMessage,
        loadingMessage: ChatMessage
    )
}
