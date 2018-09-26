//
//  JJGestureWarnningLabel.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/12.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

class JJGestureWarnningLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JJGestureWarnningLabel {
    
    /// 普通提示信息
    func showNormalMsg(_ msg : String) {
        text = msg
        textColor = JJGestureConfig.normalTextColor
    }
    
    /// 警示信息
    func showWarnMsg(_ msg : String) {
        text = msg
        textColor = JJGestureConfig.warningTextColor
    }
    
    /// 警示信息 (shake)
    func showWarnMsgAndShake(_ msg : String) {
        text = msg
        textColor = JJGestureConfig.warningTextColor
        
        // 添加 shake 动画
        layer.shake()
    }
    
    /// 成功信息
    func showSuccessMsg(_ msg : String) {
        
    }
    
}

private extension JJGestureWarnningLabel {
    
    func viewPrepare() {
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .center
    }
    
}

private extension CALayer {
    
    /// 振动
    func shake() {
        
        let kfa = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        let s : CGFloat = 5
        kfa.values = [NSNumber.init(value: Float(-s)), NSNumber.init(value: 0), NSNumber.init(value: Float(s)), NSNumber.init(value: 0), NSNumber.init(value: Float(-s)), NSNumber.init(value: 0), NSNumber.init(value: Float(s)), NSNumber.init(value: 0)]
        
        // 时长
        kfa.duration = 0.3
        // 重复
        kfa.repeatCount = 2
        // 移除
        kfa.isRemovedOnCompletion = true
        
        add(kfa, forKey: "shake")
    }
    
}
