//
//  PromptSettingViewController.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/14/24.
//

import UIKit

class PromptSettingViewController: UIViewController {
    let promptSettingView = PromptSettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        initializeHideKeyboard()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(promptSettingView)
        
        promptSettingView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges).inset(20)
        }
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
