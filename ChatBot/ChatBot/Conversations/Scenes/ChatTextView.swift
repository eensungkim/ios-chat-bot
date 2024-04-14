//
//  ChatTextView.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/1/24.
//

import UIKit

/// 텍스트필드
final class ChatTextView: UIStackView {
    private(set) var sendButton = UIButton(type: .custom).then {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: configuration)?.withTintColor(.systemCyan, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
    }

    private(set) var textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        configureUI()
        setDelegate()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ChatTextView {
    private func configureUI() {
        addArrangedSubview(textView)
        addArrangedSubview(sendButton)
        
        sendButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        guard let height = textView.font?.lineHeight else {
            return
        }
        
        textView.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(height * 6)
            $0.height.greaterThanOrEqualTo(height)
        }
    }
}

// MARK: - Life Cycle
extension ChatTextView {
    private func setUp() {
        distribution = .fill
        axis = .horizontal
        spacing = 10
        
        setUpButton()
        setUpTextView()
    }
    
    private func setUpButton() {
        sendButton.sizeToFit()
    }
    
    private func setUpTextView() {
        textView.isScrollEnabled = false
        textView.textContainer.maximumNumberOfLines = 0
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = .init(top: 8, left: 10, bottom: 8, right: 10)

        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 1.5
    }
}

// MARK: - UITextViewDelegate
extension ChatTextView: UITextViewDelegate {
    private func setDelegate() {
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        guard let lineHeight = textView.font?.lineHeight else {
            return
        }
        let maxHeight = lineHeight * 6
        
        if estimatedSize.height >= maxHeight {
            textView.isScrollEnabled = true
            textView.snp.remakeConstraints {
                $0.height.equalTo(lineHeight * 6)
            }
        } else {
            textView.isScrollEnabled = false
            textView.snp.remakeConstraints {
                $0.height.lessThanOrEqualTo(lineHeight * 6)
                $0.height.greaterThanOrEqualTo(lineHeight)
            }
        }
    }
}
