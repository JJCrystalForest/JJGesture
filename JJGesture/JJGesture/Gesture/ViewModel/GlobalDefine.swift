
import UIKit

struct GlobalDefine {
    
    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.size.height == 812
    }
    
    static let safeAreaBottomHeight : CGFloat = GlobalDefine.isIphoneX() ? 34 : 0
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenRect = UIScreen.main.bounds
    static let statusAndNaviHeight : CGFloat = GlobalDefine.isIphoneX() ? 88 : 64
    
    /// app 主题颜色
    static let appThemeColor = UIColor.hex("00893d")
    /// app 主要的字体颜色
    static let appMainFontColor = UIColor.init(white: 0, alpha: 0.8)
    /// app 一般的背景颜色
    static let baseBackgroundColor = UIColor.hex("e8e38e5")

    
}

extension UIView {
    // x
    var x:CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    // y
    var y:CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    // top
    var top:CGFloat {
        get {
            return frame.minY
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    // bottom
    var bottom:CGFloat {
        get {
            return frame.maxY
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    // left
    var left:CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    // right
    var right:CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    // CenterX
    var centerX:CGFloat {
        get {
            return frame.midX
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width/2
            frame = tempFrame
        }
    }
    
    // CenterY
    var centerY:CGFloat {
        get {
            return frame.midX
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height/2
            frame = tempFrame
        }
    }
    
    // Width
    var width:CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    
    // Height
    var height:CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    public var minX: CGFloat {
        get { return frame.origin.x }
        set { frame = CGRect(x: newValue, y: minY, width: width, height: height) }
    }
    
    public var minY: CGFloat {
        get { return frame.origin.y }
        set { frame = CGRect(x: minX, y: newValue, width: width, height: height) }
    }
    
    public var size: CGSize {
        get { return frame.size }
        set { frame = CGRect(x: minX, y: minY, width: newValue.width, height: newValue.height) }
    }
    
}

extension UIColor {
    static func hex(_ hexValue : Any) -> UIColor {
        switch hexValue {
        case let hex as Int:
            let intr = (hex >> 16) & 0xFF
            let intg = (hex >> 8) & 0xFF
            let intb = (hex) & 0xFF
            return self.init(red: CGFloat(intr)/255, green: CGFloat(intg)/255, blue: CGFloat(intb)/255, alpha: 1)
        case let hex as String:
            var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                let index = cString.index(cString.startIndex, offsetBy:1)
                cString = String(cString[index..<cString.endIndex])
            }
            
            if (cString.count != 6) {
                return self.init(red: 1, green: 0, blue: 0, alpha: 1)
            } else {
                let rIndex = cString.index(cString.startIndex, offsetBy: 2)
                let rStr = String(cString[..<rIndex])
                let otherStr = String(cString[rIndex..<cString.endIndex])
                let gIndex = otherStr.index(otherStr.startIndex, offsetBy: 2)
                let gStr = String(otherStr[..<gIndex])
                let bIndex = cString.index(cString.endIndex, offsetBy: -2)
                let bStr = String(cString[bIndex..<cString.endIndex])
                
                var intr:UInt32 = 0, intg:UInt32 = 0, intb:UInt32 = 0;
                Scanner(string: rStr).scanHexInt32(&intr)
                Scanner(string: gStr).scanHexInt32(&intg)
                Scanner(string: bStr).scanHexInt32(&intb)
                
                return self.init(red: CGFloat(intr)/255.0, green: CGFloat(intg)/255.0, blue: CGFloat(intb)/255.0, alpha: 1)
            }
        default:
            return self.init(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
    
    static func rgba(_ r : UInt, g : UInt, b : UInt, a : CGFloat) -> UIColor {
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: a)
    }
    
    static func rgb(_ r : UInt, g : UInt, b : UInt) -> UIColor {
        return rgba(r, g: g, b: b, a: 1)
    }
    
}

extension CGPoint {
    
    /// 求两个点的中点
    ///
    /// - Parameters:
    ///   - firstPoint: 第一个点
    ///   - secondPoint: 第二个点
    /// - Returns: 中点
    static func jj_center(_ firstPoint : CGPoint, _ secondPoint : CGPoint) -> CGPoint {
        let x1 = firstPoint.x > secondPoint.x ? firstPoint.x : secondPoint.x
        let x2 = firstPoint.x < secondPoint.x ? firstPoint.x : secondPoint.x
        let y1 = firstPoint.y > secondPoint.y ? firstPoint.y : secondPoint.y
        let y2 = firstPoint.y < secondPoint.y ? firstPoint.y : secondPoint.y
        return CGPoint(x: (x1 + x2) / 2, y: (y1 + y2) / 2)
    }
    
}
