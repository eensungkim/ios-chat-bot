//
//  ChatLoadingIndicator.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/28/24.
//

import UIKit

import SnapKit

/// 말풍선 로딩 인디케이터
final class ChatLoadingIndicator: UIView {
    private let leftCircle = Circle()
    private let middleCircle = Circle()
    private let rightCircle = Circle()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let bubbleWidth: CGFloat = 92
        let bubbleHeight: CGFloat = bubbleWidth * 0.36
        return CGSize(width: bubbleWidth + 20, height: bubbleHeight + 20)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let padding: CGFloat = 10
        let startX: CGFloat = rect.minX + padding
        let startY: CGFloat = rect.minY + padding
        
        let bubbleWidth: CGFloat = 92
        let bubbleHeight: CGFloat = bubbleWidth * 0.36
        
        let messageBody = CGRect(x: startX, y: startY, width: bubbleWidth, height: bubbleHeight)
        
        context?.addPath(
            CGPath(roundedRect: messageBody, cornerWidth: 10, cornerHeight: 10, transform: nil)
        )
        context?.setFillColor(UIColor.systemGray5.cgColor)
        context?.fillPath()
        
        let tailStartPoint = CGPoint(x: startX, y: startY + bubbleHeight * 0.4)
        let tailTipPoint = CGPoint(x: startX - 10, y: startY + bubbleHeight * 0.7)
        let tailEndPoint = CGPoint(x: startX, y: startY + bubbleHeight * 0.65)
        let tailControlPoint = CGPoint(x: startX - 4, y: startY + bubbleHeight * 0.73)
        
        context?.move(to: tailStartPoint)
        context?.addQuadCurve(to: tailTipPoint, control: tailControlPoint)
        context?.addQuadCurve(to: tailEndPoint, control: tailControlPoint)
        context?.setFillColor(UIColor.systemGray5.cgColor)
        context?.fillPath()
    }
}

// MARK: - UI
extension ChatLoadingIndicator {
    private func configureUI() {
        self.backgroundColor = .clear
        
        addSubview(leftCircle)
        addSubview(middleCircle)
        addSubview(rightCircle)
        
        leftCircle.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalTo(self.snp.leading).offset(24)
        }
        
        middleCircle.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalTo(leftCircle.snp.trailing).offset(14)
        }
        
        rightCircle.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalTo(middleCircle.snp.trailing).offset(14)
        }
    }
}

// MARK: - Animation
extension ChatLoadingIndicator {
    func startAnimation() {
        configureInitialState(for: leftCircle, delay: 0)
        configureInitialState(for: middleCircle, delay: 0.2)
        configureInitialState(for: rightCircle, delay: 0.4)
    }
    
    private func configureInitialState(for circle: UIView, delay: TimeInterval) {
        let dropHeight: CGFloat = -10
        circle.transform = CGAffineTransform(translationX: 0, y: dropHeight)
        circle.alpha = 0
        
        fadeInCircle(circle: circle, delay: delay)
    }
    
    private func fadeInCircle(circle: UIView, delay: TimeInterval) {
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            options: [.curveEaseIn],
            animations: {
                circle.transform = CGAffineTransform.identity
                circle.alpha = 1
            },
            completion: { [weak self] _ in
                self?.fadeOutCircle(circle: circle)
            }
        )
    }
    
    private func fadeOutCircle(circle: UIView) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.3,
            options: [],
            animations: {
                circle.alpha = 0
            },
            completion: { [weak self] _ in
                self?.configureInitialState(for: circle, delay: 0.6)
            }
        )
    }
}

// MARK: - Nested Class
extension ChatLoadingIndicator {
    final class Circle: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .clear
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let width: CGFloat = 12
            return CGSize(width: width, height: width)
        }
        
        override func draw(_ rect: CGRect) {
            let width: CGFloat = 12
            let context = UIGraphicsGetCurrentContext()
            context?.addEllipse(
                in: CGRect(x: rect.minX, y: rect.minY, width: width, height: width)
            )
            context?.setFillColor(UIColor.systemGray3.cgColor)
            context?.fillPath()
        }
    }
}
