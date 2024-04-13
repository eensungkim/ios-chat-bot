//
//  LoadingIndicatorRemoveStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/9/24.
//

import UIKit

struct LoadingIndicatorRemoveStrategy: SnapshotUpdateStrategy {
    func apply(using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>, with chatMessage: ChatMessage, loadingMessage: ChatMessage) {
        if snapshot.itemIdentifiers.contains(loadingMessage) {
            snapshot.deleteItems([loadingMessage])            
        }
    }
}
