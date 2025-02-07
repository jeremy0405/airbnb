//
//  PriceSlider.swift
//  AirbnbApp
//
//  Created by dale on 2022/06/07.
//

import UIKit
import SnapKit

final class CustomSlider: UIControl {
    // MARK: Constant
    private enum Constant {
        static let barRatio = 2.0/10.0
    }
    
    // MARK: UI
    private let lowerThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let upperThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .Custom.gray4
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let trackTintView: UIView = {
        let view = UIView()
        view.backgroundColor = .Custom.gray3
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: Properties
    var minValue = 0.0 {
        didSet { self.lower = self.minValue }
    }
    
    var maxValue = 10.0 {
        didSet { self.upper = self.maxValue }
    }
    
    var lower = 0.0 {
        didSet { self.updateLayout(self.lower, true) }
    }
    
    var upper = 0.0 {
        didSet { self.updateLayout(self.upper, false) }
    }
    
    var lowerThumbColor = UIColor.white {
        didSet { self.lowerThumbButton.backgroundColor = self.lowerThumbColor }
    }
    
    var upperThumbColor = UIColor.white {
        didSet { self.upperThumbButton.backgroundColor = self.upperThumbColor }
    }
    
    var trackColor = UIColor.gray {
        didSet { self.trackView.backgroundColor = self.trackColor }
    }
    
    var trackTintColor = UIColor.green {
        didSet { self.trackTintView.backgroundColor = self.trackTintColor }
    }
    
    private var previousTouchPoint = CGPoint.zero
    private var isLowerThumbViewTouched = false
    private var isUpperThumbViewTouched = false
    private var leftConstraint: Constraint?
    private var rightConstraint: Constraint?
    private var thumbViewLength: Double {
        Double(self.bounds.height)
    }
    
    // MARK: Init
    required init?(coder: NSCoder) {
        fatalError("xib is not implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.trackView)
        self.addSubview(self.trackTintView)
        self.addSubview(self.lowerThumbButton)
        self.addSubview(self.upperThumbButton)
        
        self.lowerThumbButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualTo(self.upperThumbButton.snp.left)
            make.left.greaterThanOrEqualToSuperview()
            make.width.equalTo(self.snp.height)
            self.leftConstraint = make.left.equalTo(self.snp.left).priority(999).constraint
        }
        
        self.upperThumbButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.lowerThumbButton.snp.right)
            make.right.lessThanOrEqualToSuperview()
            make.width.equalTo(self.snp.height)
            self.rightConstraint = make.left.equalTo(self.snp.left).priority(999).constraint
        }
        
        self.trackView.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
            make.height.equalTo(self).multipliedBy(Constant.barRatio)
        }
        
        self.trackTintView.snp.makeConstraints { make in
            make.left.equalTo(self.lowerThumbButton.snp.right)
            make.right.equalTo(self.upperThumbButton.snp.left)
            make.top.bottom.equalTo(self.trackView)
        }
    }
    
    // MARK: Touch
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        return self.lowerThumbButton.frame.contains(point) || self.upperThumbButton.frame.contains(point)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        self.previousTouchPoint = touch.location(in: self)
        self.isLowerThumbViewTouched = self.lowerThumbButton.frame.contains(self.previousTouchPoint)
        self.isUpperThumbViewTouched = self.upperThumbButton.frame.contains(self.previousTouchPoint)
        
        if self.isLowerThumbViewTouched {
            self.lowerThumbButton.isSelected = true
        } else {
            self.upperThumbButton.isSelected = true
        }
        
        return self.isLowerThumbViewTouched || self.isUpperThumbViewTouched
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        defer {
            self.previousTouchPoint = touchPoint
            self.sendActions(for: .valueChanged)
        }
        
        let drag = Double(touchPoint.x - self.previousTouchPoint.x)
        let scale = self.maxValue - self.minValue
        let scaledDrag = scale * drag / Double(self.bounds.width - self.thumbViewLength)
        
        if self.isLowerThumbViewTouched {
            self.lower = (self.lower + scaledDrag)
                .clamped(to: (self.minValue...self.upper))
        } else {
            self.upper = (self.upper + scaledDrag)
                .clamped(to: (self.lower...self.maxValue))
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.sendActions(for: .valueChanged)
        
        self.lowerThumbButton.isSelected = false
        self.upperThumbButton.isSelected = false
    }
    
    // MARK: Method
    private func updateLayout(_ value: Double, _ isLowerThumb: Bool) {
        DispatchQueue.main.async {
            let startValue = value - self.minValue
            let length = self.bounds.width - self.thumbViewLength
            let offset = startValue * length / (self.maxValue - self.minValue)
            
            if isLowerThumb {
                self.leftConstraint?.update(offset: offset)
            } else {
                self.rightConstraint?.update(offset: offset)
            }
        }
    }
    
}

class RoundableButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

final class ThumbButton: RoundableButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? .lightGray : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
