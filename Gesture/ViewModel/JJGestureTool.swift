//
//  JJGestureTool.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/19.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

class JJGestureTool {
    
    /// 是否开启手势的状态的key
    static let isEnableGestureKey = "isEnableGestureKey"
    
    /// 保存的手势密码的key
    private static let gesturePasswordKey = "gesturePasswordKey"
    
    /// 获取是否开始手势状态
    static var isGestureEnable : Bool {
        if let isEnable = UserDefaults.standard.object(forKey: JJGestureTool.isEnableGestureKey) as? Bool {
            return isEnable
        }
        return false
    }
    
    /// 获取手势密码
    static var gesturePassword : String? {
        if let pwd = UserDefaults.standard.object(forKey: gesturePasswordKey) as? String {
            return pwd
        }
        return nil
    }
    
    /// 存储是否开启手势状态
    ///
    /// - Parameter isEnable: 是否开启
    static func enableGesture(_ isEnable : Bool) {
        UserDefaults.standard.set(isEnable, forKey: JJGestureTool.isEnableGestureKey)
    }
    
    /// 存储手势密码
    ///
    /// - Parameter pwd: 手势密码
    static func saveGesture(withPassword pwd : String) {
        UserDefaults.standard.set(pwd, forKey: JJGestureTool.gesturePasswordKey)
    }
    
    /// 删除手势密码
    static func deleteGesturePassword() {
        UserDefaults.standard.removeObject(forKey: JJGestureTool.gesturePasswordKey)
    }
    
    /// 缓存中的密码是否与传入的密码一致
    ///
    /// - Parameter pwd: 手势密码
    /// - Returns: 比较结果
    static func gesturePasswordFromCacheIsEqualTo(_ pwd : String) -> Bool {
        if pwd.isEmpty { return false }
        guard let savePwd = UserDefaults.standard.object(forKey: JJGestureTool.gesturePasswordKey) as? String else { return false }
        if savePwd.isEmpty { return false }
        return pwd == savePwd
    }
    
    /// 移除手势
    static func removeGesture() {
        let lock = NSLock.init()
        lock.lock()
        UserDefaults.standard.set(false, forKey: JJGestureTool.isEnableGestureKey)
        UserDefaults.standard.removeObject(forKey: JJGestureConfig.firstGestureSaveKey)
        UserDefaults.standard.removeObject(forKey: JJGestureConfig.finalGestureSaveKey)
        UserDefaults.standard.removeObject(forKey: JJGestureConfig.gesturePwdErrorCountKey)
        lock.unlock()
    }

}
