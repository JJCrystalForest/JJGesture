//
//  JJGestureScreen.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/25.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

@objc protocol JJGestureScreenDelegate {
    @objc optional func gestureScreen(_ screen : JJGestureScreen, didSetup pwd : String)
    @objc optional func gestureScreenVerifiedSuccess()
}

class JJGestureScreen: NSObject {
    
    static let shared = JJGestureScreen()
    
    override required init() {
        window_ = UIWindow.init(frame: UIScreen.main.bounds)
        window_.windowLevel = UIWindow.Level.statusBar
        let vc = UIViewController.init()
        window_.rootViewController = vc
        super.init()
    }
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    weak var delegate : JJGestureScreenDelegate?
    
    private var window_ : UIWindow

}

extension JJGestureScreen {
    
    func show() {
        window_.isHidden = false
        window_.makeKey()
        window_.windowLevel = UIWindow.Level.statusBar
        
        let gestureVC = JJGestureViewCtrl.init(.screen)
        gestureVC.delegate = self
        gestureVC.showIn(window_.rootViewController!)
        
    }
    
    func dismiss() {
        window_.rootViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.window_.resignKey()
            self?.window_.windowLevel = UIWindow.Level.normal
            self?.window_.isHidden = true
        })
    }
    
}

extension JJGestureScreen : JJGestureViewCtrlDelegate {
    
    func verifiedSuccess(in vc: JJGestureViewCtrl) {
        
        perform(#selector(hide), with: nil, afterDelay: 0.6)
        
        delegate?.gestureScreenVerifiedSuccess?()
        
    }
    
    func cancelGesture(in vc: JJGestureViewCtrl) {
        perform(#selector(hide), with: nil, afterDelay: 0.6)
    }
    
}

private extension JJGestureScreen {
    
    @objc func hide() {
        window_.resignKey()
        window_.windowLevel =  UIWindow.Level.normal
        window_.isHidden = true
    }
    
}
