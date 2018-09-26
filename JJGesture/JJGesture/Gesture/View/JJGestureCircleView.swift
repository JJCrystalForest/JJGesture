//
//  JJGestureCircleView.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/10.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

@objc enum JJGestureCircleViewType : Int {
    /// 设置手势密码
    case setting = 1
    /// 登录手势密码
    case login
    /// 验证旧手势密码
    case verify
}

@objc protocol JJGestureCircleViewDelegate {
    
    //MARK: - 设置
    
    /// 连线个数少于 4 个时，通知代理
    ///
    /// - Parameters:
    ///   - circleView:     circle
    ///   - type:           type
    ///   - gesture:        手势结果
    @objc optional func circleView(_ circleView : JJGestureCircleView, _ type : JJGestureCircleViewType, connectCirclesLessThanNeedWithGesture gesture : String)
    
    /// 连线个数多于 4 个，获取到第一个手势密码时通知代理
    ///
    /// - Parameters:
    ///   - circelView:     circle
    ///   - type:           type
    ///   - gesture:        第一个保存的密码
    @objc optional func circleView(_ circelView : JJGestureCircleView, _ type : JJGestureCircleViewType, didCompleteSetFirstGesture gesture : String)
    
    /// 获取到第二个手势密码时通知代理
    ///
    /// - Parameters:
    ///   - circelView:     circleView
    ///   - type:           type
    ///   - gesture:        第二次手势密码
    ///   - equal:          第二次和第一次获得的手势密码匹配结果
    @objc optional func circleView(_ circelView : JJGestureCircleView, _ type : JJGestureCircleViewType, didCompleteSetSecondGesture gesture : String, result equal : Bool)
    
    //MARK: - 登录
    
    /// 登陆或者验证手势密码输入完成时的代理方法
    ///
    /// - Parameters:
    ///   - circelView:     circleView
    ///   - type:           type
    ///   - gesture:        手势
    ///   - equal:          匹配结果
    @objc optional func circleView(_ circelView : JJGestureCircleView, _ type : JJGestureCircleViewType, didCompleteLoginGesture gesture : String, result equal : Bool)
    
    /// 绘制结束（用于返回 image）
    ///
    /// - Parameters:
    ///   - circelView:     circleView
    ///   - type:           type
    ///   - gesture:        绘制结束时的图案
    @objc optional func circleView(_ circelView : JJGestureCircleView, _ type : JJGestureCircleViewType, didEndGesture gesture : String)
    
    /// 绘制结束（用于返回密码字符串）
    ///
    /// - Parameters:
    ///   - circelView:      circleView
    ///   - type:           type
    ///   - gesture:        绘制结束时的密码
    @objc optional func circleView(_ circelView : JJGestureCircleView, _ type : JJGestureCircleViewType, didEndPassword gesture : String)
    
}

class JJGestureCircleView: UIView {
    
    //MARK: - 属性
    /// 是否裁剪，默认为 true
    var isClip = true
    /// 是否有箭头，默认为 true
    var hasArrow = true {
        didSet {
            for view in subviews {
                (view as? JJGestureCircle)?.hasArrow = hasArrow
            }
        }
    }
    /// 解锁类型
    var type : JJGestureCircleViewType {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var delegate : JJGestureCircleViewDelegate?

    private var isTouchBegin = false  // 用于监控是否是开始触摸的状态
    private lazy var selectedCircles : [JJGestureCircle] = {  // 选中的圆的集合
        return [JJGestureCircle]()
    }()
    private var currentPoint = CGPoint.zero  // 当前点
    private var hasClean = false  // 是否已清空选中手势
    
    //MARK: - init
    init(_ frame : CGRect, _ type : JJGestureCircleViewType) {
        self.type = type
        super.init(frame: frame)
        lockViewPrepare()
    }
    
    init(_ type : JJGestureCircleViewType) {
        self.type = type
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.gray
        lockViewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemViewWH = JJGestureConfig.circleRadius * 2
        let marginValue = (frame.size.width - 3 * itemViewWH) / 3.0
        
        for (idx, subview) in subviews.enumerated() {
            let row = idx % 3
            let col = idx / 3
            let x = marginValue * CGFloat(row) + CGFloat(row) * itemViewWH + marginValue * 0.5
            let y = marginValue * CGFloat(col) + CGFloat(col) * itemViewWH + marginValue * 0.5
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            // 设置tag -> 密码记录的单元
            subview.tag = idx + 1
            subview.frame = frame
        }
        
        // 自己添加保存解锁图案默认图
        saveDefaultImage()
    }
    
    override func draw(_ rect: CGRect) {
        // 如果没有任何选中按钮，直接return
        if selectedCircles.count == 0 { return }
        
        guard let state = getCircleState() else { return }
        if state == .error {
            connectCircles(inRect: rect, lineColor: JJGestureConfig.errorConnectLineColor)
        } else {
            connectCircles(inRect: rect, lineColor: JJGestureConfig.normalConnectLineColor)
        }
    }
    
}

extension JJGestureCircleView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        gestureClearAndReset()
        isTouchBegin = true
        currentPoint = .zero
        let point = touch.location(in: self)
        for subview in subviews {
            guard let circle = subview as? JJGestureCircle else { return }
            if circle.frame.contains(point) == true {
                circle.state = .selected
                selectedCircles.append(circle)
            }
        }
        // 数组中最后一个对象的处理
        selectedCircles.last?.state = .lastOneSelected
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPoint = .zero
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        for subview in subviews {
            guard let circle = subview as? JJGestureCircle else { return }
            if circle.frame.contains(point) == true {
                if selectedCircles.contains(circle) == false {
                    selectedCircles.append(circle)
                    // move 过程中的连线（包含跳跃连线的处理）
                    calculateAngleAndConnectTheJumpedCircle()
                }
            } else {
                currentPoint = point
            }
        }
        
        for circle in selectedCircles {
            circle.state = .selected
            // 如果是登录或者验证原手势密码，就改为对应的状态
            if type != .setting {
                circle.state = .selected
            }
        }
        
        // 数组中最后一个对象的处理
        selectedCircles.last?.state = .lastOneSelected
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hasClean = false
        guard let result = getGestureResultStrFromSelectCircles() else { return }
        if result.count == 0 { return }
        // 手势绘制结果处理
        switch type {
        case .setting:
            gestureEndByTypeSetting(withGesture: result, length: CGFloat(result.count))
        case .login:
            gestureEndByTypeLogin(withGesture: result, length: CGFloat(result.count))
        case .verify:
            gestureEndByTypeVerify(withGesture: result, length: CGFloat(result.count))
        }
        // 手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
        errorToDisplay()
    }
    
}

extension JJGestureCircleView {
    
    /// 解锁视图准备
    private func lockViewPrepare() {
        self.frame = CGRect(x: 0, y: 0, width: GlobalDefine.screenWidth - JJGestureConfig.circleViewEdgeMargin * 2, height: GlobalDefine.screenWidth - JJGestureConfig.circleViewEdgeMargin * 2)
        self.center = CGPoint(x: GlobalDefine.screenWidth * 0.5, y: JJGestureConfig.circleViewCenterY - GlobalDefine.statusAndNaviHeight)
        
        isClip = true
        hasArrow = true
        backgroundColor = JJGestureConfig.circleBackgroundColor
        
        for _ in 1...9 {
            let circle = JJGestureCircle()
            circle.type = .gesture
            circle.hasArrow = hasArrow
            addSubview(circle)
        }
    }
    
    private func saveDefaultImage() {
        var image = UIImage.init(contentsOfFile: JJGestureConfig.gestureDefaultImagePath)
        if image == nil {
            image = shotView()
        }
    }
    
    private func shotView() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 手势结束时的清空操作
    private func gestureClearAndReset() {
        if isTouchBegin {
            isTouchBegin = false
            if let circleState = getCircleState() {
                if circleState == .selected || circleState == .lastOneSelected {
                    delegate?.circleView?(self, JJGestureCircleViewType.setting, didEndPassword: getGestureResultStrFromSelectCircles()!)
                }
            }
        }
        
        let lock = NSLock()
        lock.lock()
        if hasClean == false {
            
            // 手势完毕，选中的圆回归普通状态
            changeCircleStateInSelectedCirclesTo(.normal)
            // 清空数组
            selectedCircles.removeAll()
            // 清空方向
            resetAllCirclesDirect()
            // 改变clean的状态
            hasClean = true
            
        }
        lock.unlock()
    }
    
    /// 获取当前选中圆的状态
    private func getCircleState() -> CircleState? {
        return selectedCircles.first?.state
    }
    
    /// 将circleSet数组解析遍历，拼成手势密码字符串
    private func getGestureResultStrFromSelectCircles() -> String? {
        if selectedCircles.count == 0 { return nil }
        var result = String()
        for circle in selectedCircles {
            result.append("\(circle.tag)")
        }
        return result.isEmpty ? nil : result
    }
    
    /// 改变选中circle的子控件状态
    ///
    /// - Parameter state: 圆的状态
    private func changeCircleStateInSelectedCirclesTo(_ state : CircleState) {
        for (idx, circle) in selectedCircles.enumerated() {
            circle.state = state
            // 如果是错误状态，那就将最后一个按钮特殊处理
            if state == .error {
                if idx == selectedCircles.count - 1 {
                    circle.state = .lastOneError
                }
            }
        }
        setNeedsDisplay()
    }
    
    /// 清空所有子控件的方向
    private func resetAllCirclesDirect() {
        for circle in selectedCircles {
            circle.angle = 0
        }
    }
    
    /// 每添加一个圆，就计算一次方向
    private func calculateAngleAndConnectTheJumpedCircle() {
        if selectedCircles.count < 2 { return }
        // 取出最后一个对象
        let lastOne = (selectedCircles.last)!
        // 倒数第二个
        let lastTwo = (selectedCircles[selectedCircles.count - 2])
        // 计算位置
        let lastOneX = lastOne.center.x
        let lastOneY = lastOne.center.y
        let lastTwoX = lastTwo.center.x
        let lastTwoY = lastTwo.center.y
        
        // 1.计算角度（反正切函数）
        let angle = atan2(lastOneY - lastTwoY, lastOneX - lastTwoX) + CGFloat(Double.pi / 2)
        lastTwo.angle = angle
        
        // 2.处理跳跃连线
        let center = CGPoint.jj_center(lastOne.center, lastTwo.center)
        
        let centerCircle = enumCirclesToFindWhichSubviewContainTheCenterPoint(center)
        
        if let circle = centerCircle {
            if selectedCircles.contains(circle) == false {
                // 把跳过的圆加到数组中，它的位置是倒数第二个
                selectedCircles.insert(circle, at: selectedCircles.count - 1)
            }
        }
    }
    
    /// 给一个点，判断这个点是否被圆包围，如果包含就返回当前圆，如果不包含返回的是nil
    ///
    /// - Parameter point: 当前点
    /// - Returns: 点所在的圆
    private func enumCirclesToFindWhichSubviewContainTheCenterPoint(_ point : CGPoint) -> JJGestureCircle? {
        var centerCircle : JJGestureCircle? = nil
        for subview in subviews {
            guard let circle = subview as? JJGestureCircle else { return nil }
            if circle.frame.contains(point) {
                centerCircle = circle
            }
        }
        
        guard let circle = centerCircle else { return nil }
        
        if selectedCircles.contains(circle) == false {
            // 这个circle的角度和倒数第二个circle的角度一致
            circle.angle = selectedCircles[selectedCircles.count - 2].angle
        }
        return circle
    }
    
    /// 是否错误回显重绘
    private func errorToDisplay() {
        guard let state = getCircleState() else { return }
        if state == .error || state == .lastOneError {
            DispatchQueue.main.asyncAfter(deadline: .now() + JJGestureConfig.displayTime) {
                self.gestureClearAndReset()
            }
        } else {
            gestureClearAndReset()
        }
    }
    
    /// 将选中的图形连接起来
    ///
    /// - Parameters:
    ///   - rect: 图形上下文
    ///   - color: 连线颜色
    private func connectCircles(inRect rect : CGRect, lineColor color : UIColor) {
        
        // 获取上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        // 添加路径
        ctx.addRect(rect)
        
        // 裁剪?
        clipSubviewsWhenConnect(inContext: ctx, isClip: isClip)
        
        // 裁剪上下文
        ctx.clip()
        
        // 遍历数组中的circle
        for (index, circle) in selectedCircles.enumerated() {
            if index == 0 {  // 起点按钮
                ctx.move(to: CGPoint(x: circle.center.x, y: circle.center.y))
            } else { // 连线
                ctx.addLine(to: CGPoint(x: circle.center.x, y: circle.center.y))
            }
        }
        
        // 连接最后一个按钮到当前触摸点
        if (currentPoint == .zero) == false {
            for _ in subviews {
                guard let state = getCircleState() else { return }
                if state == .error || state == .lastOneError {
                    // 错误状态下不连接到当前点
                } else {  // 正确状态
                    ctx.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                }
            }
        }
        
        // 设置线条属性
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        ctx.setLineWidth(JJGestureConfig.connectLineWidth)
        color.set()
        
        // 渲染路径
        ctx.strokePath()
        
    }
    
    /// 是否裁剪子控件
    ///
    /// - Parameters:
    ///   - ctx: 图形上下文
    ///   - isClip: 是否裁剪
    private func clipSubviewsWhenConnect(inContext ctx : CGContext, isClip : Bool) {
        if isClip == true {
            for subview in subviews {
                guard let circle = subview as? JJGestureCircle else { return }
                ctx.addEllipse(in: circle.frame)
            }
        }
    }
    
}

extension JJGestureCircleView {
    /// 解锁类型：设置，手势路径的处理
    ///
    /// - Parameters:
    ///   - gesture: 手势密码
    ///   - length: 长度
    private func gestureEndByTypeSetting(withGesture gesture : String, length : CGFloat) {
        if length < CGFloat(JJGestureConfig.minCircleCount) {  // 连接少于最少个数
            // 1、通知代理
            delegate?.circleView?(self, type, connectCirclesLessThanNeedWithGesture: gesture)
            // 2、改变状态为error
            changeCircleStateInSelectedCirclesTo(.error)
        } else {  // 连接大于或等于最少个数
            if let gestureOne = JJGestureConfig.getGesture(withKey: JJGestureConfig.firstGestureSaveKey) {
                let isEqual = (gesture == gestureOne)
                delegate?.circleView?(self, type, didCompleteSetSecondGesture: gesture, result: isEqual)
                if isEqual == true { // 接受第二个密码并与第一个密码匹配，一致后存储起来
                    // 一致，存储密码
                    JJGestureConfig.saveGesture(gesture, JJGestureConfig.finalGestureSaveKey)
                } else {
                    // 不一致，重绘回退
                    changeCircleStateInSelectedCirclesTo(.error)
                }
            } else { // 接收并存储第一个密码
                delegate?.circleView?(self, type, didCompleteSetFirstGesture: gesture)
            }
        }
    }
    
    /// 解锁类型：登录，手势路径的处理
    ///
    /// - Parameters:
    ///   - gesture: 手势密码
    ///   - length: 长度
    private func gestureEndByTypeLogin(withGesture gesture : String, length : CGFloat) {
        guard let pwd = JJGestureConfig.getGesture(withKey: JJGestureConfig.finalGestureSaveKey) else { return }
        let isEqual = (gesture == pwd)
        delegate?.circleView?(self, type, didCompleteLoginGesture: gesture, result: isEqual)
        if isEqual == false {
            changeCircleStateInSelectedCirclesTo(.error)
        }
    }
    
    /// 解锁类型：验证，手势路径的处理
    ///
    /// - Parameters:
    ///   - gesture: 手势密码
    ///   - length: 长度
    private func gestureEndByTypeVerify(withGesture gesture : String, length : CGFloat) {
        gestureEndByTypeLogin(withGesture: gesture, length: length)
    }
}
