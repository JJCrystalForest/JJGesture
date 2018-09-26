//
//  JJGestureCircle.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/10.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

/// 单个圆的各种状态
enum CircleState : Int {
    case normal = 1
    case selected
    case error
    case lastOneSelected
    case lastOneError
}

/// 单个圆的用途类型
enum CircleType : Int {
    case info = 1
    case gesture
}

class JJGestureCircle: UIView {

    //MARK: - 属性
    var state = CircleState.normal {
        didSet {
            setNeedsDisplay()
        }
    }
    var type : CircleType = .gesture
    /// 箭头
    var hasArrow = true
    /// 角度
    var angle : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = JJGestureConfig.circleBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = JJGestureConfig.circleBackgroundColor
    }
    
    //MARK: - 重写
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        var radio : CGFloat = 1
        let circleRect = CGRect(x: JJGestureConfig.circleEdgeWidth, y: JJGestureConfig.circleEdgeWidth, width: rect.size.width - 2 * JJGestureConfig.circleEdgeWidth, height: rect.size.height - 2 * JJGestureConfig.circleEdgeWidth)
        
        switch type {
        case .gesture: radio = JJGestureConfig.circleInsideRadio
        case .info: radio = 1
        }
        
        // 上下文旋转
        transfromCtx(ctx, rect)
        
        // 画圆环
        drawEmptyCircle(withContext: ctx, rect: circleRect, color: outCircleColor)
        
        // 画实心圆
        drawSolidCircle(withContext: ctx, rect: rect, radio: radio, color: inCircleColor)
        
        if hasArrow == true {
            // 画三角形箭头
            drawTrangle(withContext: ctx, topPoint: CGPoint(x: rect.size.width * 0.5, y: 10), length: JJGestureConfig.trangleLength, color: trangleColor)
        }
    }
    
}

extension JJGestureCircle {
    
    /// 上下文旋转
    ///
    /// - Parameters:
    ///   - ctx: 图形上下文
    ///   - rect: 绘制范围
    private func transfromCtx(_ ctx : CGContext, _ rect : CGRect) {
        let translateXY = rect.size.width * 0.5
        ctx.translateBy(x: translateXY, y: translateXY)  // 平移
        ctx.rotate(by: angle)
        ctx.translateBy(x: -translateXY, y: -translateXY)  // 再平移回来
    }
    
    /// 画外圆环
    ///
    /// - Parameters:
    ///   - ctx: 图形上下文
    ///   - rect: 绘图范围
    ///   - color: 绘制颜色
    private func drawEmptyCircle(withContext ctx : CGContext, rect : CGRect, color : UIColor) {
        let circlePath = CGMutablePath.init()
        circlePath.addEllipse(in: rect)
        ctx.addPath(circlePath)
        color.set()
        ctx.setLineWidth(JJGestureConfig.circleEdgeWidth)
        ctx.strokePath()
    }
    
    /// 画实心圆
    ///
    /// - Parameters:
    ///   - ctx: 图形上下文
    ///   - rect: 绘制范围
    ///   - radio: 占大图比例
    ///   - color: 绘制颜色
    private func drawSolidCircle(withContext ctx : CGContext, rect : CGRect, radio : CGFloat, color : UIColor) {
        let circlePath = CGMutablePath.init()
        let newRect = CGRect(x: rect.size.width/2 * (1 - radio) + JJGestureConfig.circleEdgeWidth, y: rect.size.height / 2 * (1 - radio) + JJGestureConfig.circleEdgeWidth, width: rect.size.width * radio - JJGestureConfig.circleEdgeWidth * 2, height: rect.size.height * radio - JJGestureConfig.circleEdgeWidth * 2)
        circlePath.addEllipse(in: newRect)
        color.set()
        ctx.addPath(circlePath)
        ctx.fillPath()
    }
    
    /// 画三角形
    ///
    /// - Parameters:
    ///   - ctx: 图形上下文
    ///   - point: 顶点
    ///   - length: 边长
    ///   - color: 绘制颜色
    private func drawTrangle(withContext ctx : CGContext, topPoint point : CGPoint, length : CGFloat, color : UIColor) {
        let tranglePathM = CGMutablePath.init()
        tranglePathM.move(to: point)
        tranglePathM.addLine(to: CGPoint(x: point.x - length * 0.5, y: point.y + length * 0.5))
        tranglePathM.addLine(to: CGPoint(x: point.x + length * 0.5, y: point.y + length * 0.5))
        ctx.addPath(tranglePathM)
        color.set()
        ctx.fillPath()
    }
}

extension JJGestureCircle {
    /// 外环颜色
    private var outCircleColor : UIColor {
        get {
            switch state {
            case .normal:
                return JJGestureConfig.normalOutsideCircleColor
            case .selected:
                return JJGestureConfig.selectedOutsideCircleColor
            case .error:
                return JJGestureConfig.errorOutsideCircleColor
            case .lastOneSelected:
                return JJGestureConfig.selectedOutsideCircleColor
            case .lastOneError:
                return JJGestureConfig.errorOutsideCircleColor
            }
        }
    }
    
    /// 实心圆颜色
    private var inCircleColor : UIColor {
        get {
            switch state {
            case .normal:
                return JJGestureConfig.normalInsideCircleColor
            case .selected:
                return JJGestureConfig.selectedInsideCircleColor
            case .error:
                return JJGestureConfig.errorInsideCircleColor
            case .lastOneSelected:
                return JJGestureConfig.selectedInsideCircleColor
            case .lastOneError:
                return JJGestureConfig.errorInsideCircleColor
            }
        }
    }
    
    /// 三角形颜色
    private var trangleColor : UIColor {
        get {
            switch state {
            case .normal:
                return JJGestureConfig.normalTrangleColor
            case .selected:
                return JJGestureConfig.selectedTrangleColor
            case .error:
                return JJGestureConfig.errorTrangleColor
            case .lastOneSelected:
                return JJGestureConfig.normalTrangleColor
            case .lastOneError:
                return JJGestureConfig.normalTrangleColor
            }
        }
    }
}
