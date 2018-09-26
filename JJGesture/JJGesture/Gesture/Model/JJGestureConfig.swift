//
//  JJGestureConfig.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/10.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

struct JJGestureConfig {
    
    /// 单个圆背景色
    static let circleBackgroundColor = UIColor.clear
    
    /// 解锁背景色
    static let circleViewBackgroundColor = UIColor.hex("f8f8f8")
    
    /// 普通状态下外空心圆颜色
    static let normalOutsideCircleColor = UIColor.hex("8e8e8e")
    
    /// 选中状态下外空心圆颜色
    static let selectedOutsideCircleColor = GlobalDefine.appThemeColor
    
    /// 错误状态下外空心圆颜色
    static let errorOutsideCircleColor = UIColor.rgb(254, g: 82, b: 92)
    
    /// 普通状态下实心圆颜色
    static let normalInsideCircleColor = UIColor.clear
    
    /// 选中状态下实心圆颜色
    static let selectedInsideCircleColor = GlobalDefine.appThemeColor
    
    /// 错误状态下实心圆颜色
    static let errorInsideCircleColor = UIColor.rgb(254, g: 82, b: 92)
    
    /// 普通状态下三角形颜色
    static let normalTrangleColor = UIColor.clear
    
    /// 选中状态下三角形颜色
    static let selectedTrangleColor = GlobalDefine.appThemeColor
    
    /// 错误状态下三角形颜色
    static let errorTrangleColor = UIColor.rgb(254, g: 82, b: 92)
    
    /// 三角形边长
    static let trangleLength : CGFloat = 10.0
    
    /// 普通状态下连线颜色
    static let normalConnectLineColor = GlobalDefine.appThemeColor
    
    /// 错误状态下连线颜色
    static let errorConnectLineColor = UIColor.rgb(254, g: 82, b: 92)
    
    /// 连线宽度
    static let connectLineWidth : CGFloat = 1.0
    
    /// 单个圆的半径
    static let circleRadius : CGFloat = 30.0
    
    /// 单个圆的圆心
    static let circleCenter = CGPoint(x: JJGestureConfig.circleRadius, y: JJGestureConfig.circleRadius)
    
    /// 空心圆圆环宽度
    static let circleEdgeWidth : CGFloat = 1.0
    
    /// 九宫格展示 infoView 单个圆的半径
    static let circleInfoRadius = 5.0
    
    /// 内部空心圆占空心圆的比例系数
    static let circleInsideRadio : CGFloat = 0.4
    
    /// 整个解锁 view 居中时，距离屏幕左边和右边的距离
    static let circleViewEdgeMargin : CGFloat = 30.0
    
    /// 整个解锁 view 的center.y 的值，在当前屏幕的位置
    static let circleViewCenterY = GlobalDefine.screenHeight * 3 / 5
    
    /// 连接的圆的最少个数
    static let minCircleCount = 4
    
    /// 错误状态下回显的时间
    static let displayTime : TimeInterval = 1.0
    
    /// 最终的手势密码存储key
    static let finalGestureSaveKey = "finalGestureSaveKey"
    
    /// 第一个手势密码存储key
    static let firstGestureSaveKey = "firstGestureSaveKey"
    
    /// 手势默认图片路径
    static let gestureDefaultImagePath = (NSHomeDirectory() as NSString).appendingPathComponent("Documents/gestureDefaultImage.png")
    
    /// 普通状态下文字提示的颜色
    static let normalTextColor = GlobalDefine.appThemeColor
    
    /// 警告状态下文字提示的颜色
    static let warningTextColor = GlobalDefine.appThemeColor
    
    /// 绘制解锁界面准备好时，提示文字
    static let promptTextBeforeSet = "设置手势密码"
    
    /// 设置时，连线数少，提示文字
    static let promptTextConnectLess = "密码至少\(JJGestureConfig.minCircleCount)位"
    
    /// 确认图案，提示再次绘制文字
    static let promptTextDrawAgain = "再次绘制解锁图案"
    
    /// 再次绘制不一致，提示文字
    static let prpmptTextDrawAgainError = "两次绘制解锁图案不一致"
    
    /// 设置成功，提示文字
    static let promptTextSetSuccess = "设置密码成功"
    
    /// 请输入原手势密码，提示文字
    static let promptTextOldGesture = "请输入原手势密码"
    
    /// 密码错误，提示文字
    static let promptTextVerifyError = "密码错误"
    
    /// 新密码不能与旧密码相同
    static let promptTextPwdIsSame = "新密码与旧密码不能相同"
    
    /// 保存密码错误次数的key
    static let gesturePwdErrorCountKey = "gesturePwdErrorCountKey"
    
    /// 手势密码允许错误的最大次数
    static let maxGestureErrorCount = 10
    
    /// 偏好设置：存字符串（手势密码）
    ///
    /// - Parameters:
    ///   - gesture: 字符串对象
    ///   - key: 存储的key
    static func saveGesture(_ gesture : String, _ key : String) {
        UserDefaults.standard.set(gesture, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// 偏好设置，取字符串（手势密码）
    ///
    /// - Parameter key: 存储的key
    /// - Returns: 字符串对象
    static func getGesture(withKey key : String) -> String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
}
