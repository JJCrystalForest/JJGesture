//
//  JJGestureViewCtrl.swift
//  Schaeffler
//
//  Created by crystalforest on 2018/9/7.
//  Copyright © 2018年 crystalforest. All rights reserved.
//

import UIKit

enum JJGestureViewCtrlType : Int {
    case setting = 0
    case verify
    case update
    case screen
}

@objc protocol JJGestureViewCtrlDelegate {
    
    /// 设置完成
    @objc optional func gestureViewCtrl(_ vc : JJGestureViewCtrl, didSetted pwd : String)
    /// 更新完成
    @objc optional func gestureViewCtrl(_ vc : JJGestureViewCtrl, didUpdate pwd : String)
    /// 验证成功
    @objc optional func verifiedSuccess(in vc : JJGestureViewCtrl)
    /// 验证失败
    @objc optional func verifiedFailed(in vc : JJGestureViewCtrl)
    /// 取消
    @objc optional func cancelGesture(in vc : JJGestureViewCtrl)
    
}

class JJGestureViewCtrl: UIViewController {
    
    var type : JJGestureViewCtrlType
    
    private lazy var lockView : JJGestureCircleView = {
        var lockView : JJGestureCircleView
        switch type {
            case .setting:
                lockView = JJGestureCircleView.init(.setting)
            case .verify:
                lockView = JJGestureCircleView.init(.login)
            case .update:
                lockView = JJGestureCircleView.init(.verify)
            case .screen:
                lockView = JJGestureCircleView.init(.login)
        }
        lockView.delegate = self
        return lockView
    }()
    
    private lazy var diagramView : JJGestureDiagramView = {
        let diagramView = JJGestureDiagramView.init(frame: CGRect(x: 0, y: 0, width: JJGestureConfig.circleRadius * 4 * 0.6, height: JJGestureConfig.circleRadius * 4 * 0.6))
        diagramView.center = CGPoint(x: GlobalDefine.screenWidth * 0.5, y: msgLabel.frame.minY - 20 - diagramView.height / 2)
        diagramView.backgroundColor = UIColor.clear
        return diagramView
    }()
    
    private lazy var msgLabel : JJGestureWarnningLabel = {
        let msgLabel = JJGestureWarnningLabel.init(frame: CGRect(x: 0, y: 0, width: GlobalDefine.screenWidth, height: 40))
        msgLabel.numberOfLines = 2
        msgLabel.center = CGPoint(x: GlobalDefine.screenWidth * 0.5, y: lockView.frame.minY - 30)
        return msgLabel
    }()
    
    private lazy var forgetBtn : UIButton = {
        let forgetBtn = UIButton.init(type: .custom)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgetBtn.setTitle("忘记手势密码？", for: .normal)
        forgetBtn.setTitleColor(GlobalDefine.appThemeColor, for: .normal)
        forgetBtn.sizeToFit()
        forgetBtn.frame = CGRect(x: 0, y: lockView.frame.maxY + 20, width: forgetBtn.width, height: forgetBtn.height)
        forgetBtn.right = lockView.right
        forgetBtn.addTarget(self, action: #selector(self.forgetBtnClick), for: .touchUpInside)
        return forgetBtn
    }()
    
    private var isShowDefaultDiagramView = false
    
    weak var delegate : JJGestureViewCtrlDelegate?
    
    init(_ type : JJGestureViewCtrlType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        msgLabel.showWarnMsg("请输入手势密码")
        
        view.addSubview(lockView)
        
        view.addSubview(msgLabel)
        
        view.addSubview(diagramView)
        
        view.addSubview(forgetBtn)
        
        addNaviBackItem()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.removeObject(forKey: JJGestureConfig.firstGestureSaveKey)
    }
    
}

extension JJGestureViewCtrl {  // api
    func showIn(_ vc : UIViewController) {
        
        let nvc = UINavigationController.init(rootViewController: self)
        vc.present(nvc, animated: true, completion: nil)
        
        switch type {
            case .setting:
                gestureSetting()
            case .verify:
                gestureVerify()
            case .update:
                gestureUpdate()
            case .screen:
                gestureScreen()
        }
        
    }
    
}

private extension JJGestureViewCtrl {
    
    func gestureSetting() {
        title = "设置手势密码"
        msgLabel.showNormalMsg(JJGestureConfig.promptTextBeforeSet)
        diagramView.showImage(withPassword: nil)
        forgetBtn.isHidden = true
    }
    
    func gestureVerify() {
        title = "验证手势密码"
        diagramView.isHidden = true
        forgetBtn.isHidden = false
    }
    
    func gestureUpdate() {
        title = "更新手势密码"
        diagramView.isHidden = true
        forgetBtn.isHidden = false
    }
    
    func gestureScreen() {
        title = "解锁"
        diagramView.isHidden = true
        forgetBtn.isHidden = false
    }
    
    @objc func forgetBtnClick() {
        let alertVC = UIAlertController(title: "提醒", message: "将会删除所有手势信息", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
        let confirm = UIAlertAction(title: "确定", style: .default) { (action) in
            JJGestureTool.removeGesture()
            self.dismiss()
            self.delegate?.cancelGesture?(in: self)
        }
        alertVC.addAction(confirm)
        present(alertVC, animated: true, completion: nil)
    }
    
    func addNaviBackItem() {
        let item = UIBarButtonItem(image: UIImage.init(named: "back_icon"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func back() {
        dismiss()
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 通过pwd加密数据库
    func encryptionSqlite(with pwd : String) -> Bool {
        guard let realPwd = UserDefaults.standard.value(forKey: JJGestureConfig.finalGestureSaveKey) as? String else { return false }
        if realPwd == pwd {
            return true
        } else {
            return false
        }
    }
    
    /// 限制输入手势密码次数
    func checkPwdCount() {
        var gestureErrorCount = 0
        if let count = UserDefaults.standard.value(forKey: JJGestureConfig.gesturePwdErrorCountKey) as? Int {
            gestureErrorCount = count
        }
        gestureErrorCount += 1
        let remainCount = JJGestureConfig.maxGestureErrorCount - gestureErrorCount
        if remainCount == 0 {  // 达到最大错误次数，清除数据
            DispatchQueue.main.async {
                JJGestureTool.removeGesture()
            }
            let alertVC = UIAlertController(title: "提醒", message: "将会删除所有手势信息", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "确定", style: .cancel) { (action) in
                self.dismiss()
                self.delegate?.cancelGesture?(in: self)
            }
            alertVC.addAction(confirm)
            present(alertVC, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(gestureErrorCount, forKey: JJGestureConfig.gesturePwdErrorCountKey)
        }
        msgLabel.showWarnMsgAndShake("剩余\(remainCount)次失败尝试，达到将会删除所有手势信息")
    }
    
}

extension JJGestureViewCtrl : JJGestureCircleViewDelegate {
    
    /// 连接个数少于最少个数
    ///
    /// - Parameters:
    ///   - circleView: circleView
    ///   - type:       type
    ///   - gesture:    手势密码
    func circleView(_ circleView: JJGestureCircleView, _ type: JJGestureCircleViewType, connectCirclesLessThanNeedWithGesture gesture: String) {
        msgLabel.showWarnMsgAndShake(JJGestureConfig.promptTextConnectLess)
    }
    
    /// 获取到第一个手势密码时
    ///
    /// - Parameters:
    ///   - circelView: circelView
    ///   - type:       type
    ///   - gesture:    需要保存的手势密码
    func circleView(_ circelView: JJGestureCircleView, _ type: JJGestureCircleViewType, didCompleteSetFirstGesture gesture: String) {
        
        if JJGestureTool.isGestureEnable {  // 开启了手势
            let result = encryptionSqlite(with: gesture)
            if result { // 新密码与旧密码不能相同
                msgLabel.showWarnMsgAndShake(JJGestureConfig.promptTextPwdIsSame)
            } else {
                // 记录第一次密码
                JJGestureConfig.saveGesture(gesture, JJGestureConfig.firstGestureSaveKey)
                msgLabel.showWarnMsg(JJGestureConfig.promptTextDrawAgain)
            }
        } else {
            // 记录第一次密码
            JJGestureConfig.saveGesture(gesture, JJGestureConfig.firstGestureSaveKey)
            msgLabel.showWarnMsg(JJGestureConfig.promptTextDrawAgain)
        }
        
    }
    
    /// 获取到第二个手势密码时
    ///
    /// - Parameters:
    ///   - circelView: circleView
    ///   - type:       type
    ///   - gesture:    第二次手势密码
    ///   - equal:      第二次和第一次获得的手势密码匹配结果
    func circleView(_ circelView: JJGestureCircleView, _ type: JJGestureCircleViewType, didCompleteSetSecondGesture gesture: String, result equal: Bool) {
        if equal {  // 匹配
            print(JJGestureConfig.promptTextSetSuccess)
            // 已开启手势
            JJGestureTool.enableGesture(true)
            dismiss()
            if self.type == .update {
                delegate?.gestureViewCtrl?(self, didUpdate: gesture)
            } else {
                delegate?.gestureViewCtrl?(self, didSetted: gesture)
            }
        } else {  // 不匹配
            msgLabel.showWarnMsgAndShake(JJGestureConfig.prpmptTextDrawAgainError)
        }
    }
    
    /// 登录或验证手势密码输入完成时的代理方法
    ///
    /// - Parameters:
    ///   - circelView: circleView
    ///   - type:       type
    ///   - gesture:    手势密码
    ///   - equal:      验证结果
    func circleView(_ circelView: JJGestureCircleView, _ type: JJGestureCircleViewType, didCompleteLoginGesture gesture: String, result equal: Bool) {
        // 此时的 type 有两种情况，login or verify
        if type == .login {
            let result = encryptionSqlite(with: gesture)
            if result {  // 密码一致，验证成功
                let lock = NSLock.init()
                lock.lock()
                UserDefaults.standard.removeObject(forKey: JJGestureConfig.gesturePwdErrorCountKey)
                lock.unlock()
                dismiss()
                delegate?.verifiedSuccess?(in: self)
            } else {  // 验证失败
                delegate?.verifiedFailed?(in: self)
                checkPwdCount()
            }
        } else if type == .verify {
            let result = encryptionSqlite(with: gesture)
            if result {
                JJGestureTool.removeGesture()
                lockView.type = .setting
                msgLabel.showNormalMsg(JJGestureConfig.promptTextBeforeSet)
                title = "设置手势密码"
                isShowDefaultDiagramView = true
                forgetBtn.isHidden = true
            } else {
                checkPwdCount()
            }
        }
    }
    
    /// 绘制结束
    ///
    /// - Parameters:
    ///   - circelView: circleView
    ///   - type:       type
    ///   - gesture:    手势密码
    func circleView(_ circelView: JJGestureCircleView, _ type: JJGestureCircleViewType, didEndPassword gesture: String) {
        if type == .setting {
            if self.type == .screen { return }
            if isShowDefaultDiagramView {
                diagramView.isHidden = false
                diagramView.showImage(withPassword: nil)
                isShowDefaultDiagramView = false
            } else {
                diagramView.showImage(withPassword: gesture)
            }
        }
    }
    
}
