//
//  PromptSettingView.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/14/24.
//

import UIKit

import Then

final class PromptSettingView: UIView {
    private let title = UILabel().then {
        $0.text = "PromptSetting"
        $0.textColor = .systemCyan
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    private let textView = UITextView().then {
        let borderColor: UIColor = .systemGray3
        $0.layer.borderWidth = 2
        $0.layer.borderColor = borderColor.cgColor
        $0.layer.cornerRadius = 5.0
        
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PromptSettingView {
    private func configureUI() {
        addSubview(title)
        addSubview(textView)
        
        title.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(20)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
    }
}
