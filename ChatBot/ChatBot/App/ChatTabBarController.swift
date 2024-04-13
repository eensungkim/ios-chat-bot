//
//  ChatTabBarController.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/13/24.
//

import UIKit

class ChatTabBarController: UITabBarController {
    enum Tab {
        case conversations
        case promptSetting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Configurations
extension ChatTabBarController {
    private func configure() {
        let chatViewController = ChatViewController()
        chatViewController.tabBarItem = Tab.conversations.tabBarItem
        setViewControllers([chatViewController], animated: true)
    }
}

extension ChatTabBarController.Tab {
    var tabBarItem: UITabBarItem {
        switch self {
        case .conversations:
            return UITabBarItem(
                title: "Conversations",
                image: UIImage(systemName: "bubble.left.and.bubble.right"),
                tag: 0
            )
        case .promptSetting:
            return UITabBarItem(
                title: "Prompt Setting",
                image: UIImage(systemName: "gearshape.fill"),
                tag: 1
            )
        }
    }
}
