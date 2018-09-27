# JJGesture

封装的一个简单易用的手势密码控件（swift）

可直接通过下载demo查看使用。

## 使用方法

1、设置手势密码

    let gestureVC = JJGestureViewCtrl.init(.setting)
    gestureVC.showIn(self)

2、验证手势密码

    let gestureVC = JJGestureViewCtrl.init(.verify)
    gestureVC.showIn(self)

3、修改手势密码

    let gestureVC = JJGestureViewCtrl.init(.update)
    gestureVC.showIn(self)

4、锁屏的时候验证可以直接使用

    JJGestureScreen.shared.show()

## 示例
### 设置手势密码
![](https://github.com/JJCrystalForest/JJGesture/blob/master/setting.gif)
### 验证手势密码
![](https://github.com/JJCrystalForest/JJGesture/blob/master/verify.gif)
### 修改手势密码
![](https://github.com/JJCrystalForest/JJGesture/blob/master/change.gif)
### 忘记手势密码
![](https://github.com/JJCrystalForest/JJGesture/blob/master/forget.gif)
