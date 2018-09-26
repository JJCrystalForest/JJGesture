//
//  JJGestureDiagramView.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/12.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

class JJGestureDiagramView: UIView {
    
    private lazy var pwdAry_ : [String] = {
        return Array.init()
    }()
    private let itemViewWH : CGFloat = 13
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let marginValue = (width - 3 * itemViewWH) / 3
        for i in 0..<9 {
            let row : CGFloat = CGFloat(i % 3)
            let col : CGFloat = CGFloat(i / 3)
            let x = marginValue * row + row * itemViewWH + marginValue / 2
            let y = marginValue * col + col * itemViewWH + marginValue / 2
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            var isFill = false
            var color = UIColor.hex("8e8e8e")
            for pwd in pwdAry_ {
                guard let pwdInt = Int(pwd) else { return }
                if pwdInt - 1 == i {
                    isFill = true
                    color = GlobalDefine.appThemeColor
                }
            }
            drawEmptyCircle(withContext: ctx, rect: frame, color: color, isFill: isFill)
        }
    }
    
}

extension JJGestureDiagramView {
    
    func showImage(withPassword pwd : String?) {
        guard let pwd = pwd else { return }
        pwdAry_.removeAll()
        for char in pwd.enumerated() {
            pwdAry_.append(String.init(char.element))
        }
        setNeedsDisplay()
    }
    
}

private extension JJGestureDiagramView {
    
    func drawEmptyCircle(withContext ctx : CGContext, rect : CGRect, color : UIColor, isFill : Bool) {
        let circlePath = CGMutablePath.init()
        circlePath.addEllipse(in: rect)
        ctx.addPath(circlePath)
        color.set()
        ctx.setLineWidth(1.0)
        if isFill == false { ctx.strokePath() }
        ctx.fillPath()
    }
    
}
