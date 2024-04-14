//
//  ChatBubbleView.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/28/24.
//

import UIKit

import SnapKit
import Then

/// 말풍선 View
class ChatBubbleView: UIView {
    private(set) var textLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private(set) var bubbleBackgroundColor: CGColor = UIColor.systemGray5.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ChatBubbleView {
    private func configureUI() {
        backgroundColor = .clear
        contentMode = .redraw
        
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.edges.equalTo(self).inset(UIEdgeInsets(
                top: 20,
                left: 20,
                bottom: 20,
                right: 20
            ))
        }
    }
}

// MARK: - Public Methods
extension ChatBubbleView {
    func setText(_ text: String) {
        textLabel.text = text
    }
    
    func setBubbleBackgroundColor(_ color: CGColor) {
        bubbleBackgroundColor = color
    }
    
    func setTextColor(_ color: UIColor) {
        textLabel.textColor = color
    }
}

/// UserChatBubbleView
final class UserChatBubbleView: ChatBubbleView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let padding: CGFloat = 10
        let startX: CGFloat = rect.minX + padding
        let startY: CGFloat = rect.minY + padding
        let endX: CGFloat = rect.maxX - padding
        let endY: CGFloat = rect.maxY - padding
        
        let bubbleWidth: CGFloat = endX - startX
        let bubbleHeight: CGFloat = endY - startY
        
        let messageBody = CGRect(x: startX, y: startY, width: bubbleWidth, height: bubbleHeight)
        
        context?.addPath(CGPath(roundedRect: messageBody, cornerWidth: 10, cornerHeight: 10, transform: nil))
        context?.setFillColor(bubbleBackgroundColor)
        context?.fillPath()
        
        let tailStartPoint = CGPoint(x: endX, y: endY - 25)
        let tailTipPoint = CGPoint(x: endX + 10, y: endY - 15)
        let tailEndPoint = CGPoint(x: endX, y: endY - 15)
        let tailControlPoint = CGPoint(x: endX + 3, y: endY - 13)
        
        context?.move(to: tailStartPoint)
        context?.addQuadCurve(to: tailTipPoint, control: tailControlPoint)
        context?.addQuadCurve(to: tailEndPoint, control: tailControlPoint)
        context?.setFillColor(bubbleBackgroundColor)
        context?.fillPath()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.textColor = .white
        setBubbleBackgroundColor(UIColor.systemBlue.cgColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// AssistantChatBubbleView
final class AssistantChatBubbleView: ChatBubbleView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let padding: CGFloat = 10
        let startX: CGFloat = rect.minX + padding
        let startY: CGFloat = rect.minY + padding
        let endX: CGFloat = rect.maxX - padding
        let endY: CGFloat = rect.maxY - padding
        
        let bubbleWidth: CGFloat = endX - startX
        let bubbleHeight: CGFloat = endY - startY
        
        let messageBody = CGRect(x: startX, y: startY, width: bubbleWidth, height: bubbleHeight)
        
        context?.addPath(CGPath(roundedRect: messageBody, cornerWidth: 10, cornerHeight: 10, transform: nil))
        context?.setFillColor(bubbleBackgroundColor)
        context?.fillPath()
        
        let tailStartPoint = CGPoint(x: startX, y: endY - 25)
        let tailTipPoint = CGPoint(x: startX - 10, y: endY - 15)
        let tailEndPoint = CGPoint(x: startX, y: endY - 15)
        let tailControlPoint = CGPoint(x: startX - 3, y: endY - 13)
        
        context?.move(to: tailStartPoint)
        context?.addQuadCurve(to: tailTipPoint, control: tailControlPoint)
        context?.addQuadCurve(to: tailEndPoint, control: tailControlPoint)
        context?.setFillColor(bubbleBackgroundColor)
        context?.fillPath()
    }
}
