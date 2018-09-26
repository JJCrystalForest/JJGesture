//
//  ViewController.swift
//  JJGesture
//
//  Created by crystalforest on 2018/9/26.
//  Copyright © 2018 crystalforest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(UINib.init(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCellID")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let dataAry = ["设置手势密码", "验证手势密码", "修改手势密码", "取消手势密码"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCellID") as! NormalTableViewCell
        cell.titleLb.text = dataAry[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:  // 设置
            let gestureVC = JJGestureViewCtrl.init(.setting)
            gestureVC.showIn(self)
        case 1:  // 验证
            if JJGestureTool.isGestureEnable {
                let gestureVC = JJGestureViewCtrl.init(.verify)
                gestureVC.showIn(self)
            } else {
                print("请先设置手势密码")
            }
        case 2: // 修改
            if JJGestureTool.isGestureEnable {
                let gestureVC = JJGestureViewCtrl.init(.update)
                gestureVC.showIn(self)
            } else {
                print("请先设置手势密码")
            }
        case 3: // 取消
            JJGestureTool.removeGesture()
            JJGestureTool.enableGesture(false)
        default:
            print("么西么西")
        }
    }
    
}

