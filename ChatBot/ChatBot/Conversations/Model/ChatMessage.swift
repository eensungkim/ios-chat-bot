//
//  ChatMessage.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/4/24.
//

import Foundation

struct ChatMessage: Hashable {
    let id: UUID
    let role: ChatRole
    let message: String
    private(set) var showRefreshButton: Bool
    
    mutating func toggleRefreshButton() {
        showRefreshButton.toggle()
    }
    
    func convert() -> Message {
        return Message(
            role: self.role,
            content: self.message)
    }
}
