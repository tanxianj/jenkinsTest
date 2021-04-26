//
//  BaseTools.swift
//  Swift学习
//
//  Created by 谭显敬 on 2020/10/24.
//  Copyright © 2020 谭显敬 联系QQ :1079139185 Wx:xj1079139185. All rights reserved.
//

import Foundation
import UIKit

/// 调试方法打印输出

 public func txjLog<T>(_ message: T, filePath: String = #file, function:String = #function, rowCount: Int = #line) {
     #if DEBUG
     let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
     print("👉\n文件: " + fileName + "\n\(rowCount)" +
    "  行" + "\n方法名: " + "\(function)" + "\n内容->:\n 👇👇👇\n\(message)\n👆👆👆\n👈")
     #endif
 }
extension UIView{
    
    /// 创建UIView
    /// - Parameters:
    ///   - c: 背景颜色
    ///   - xy: xy
    ///   - size: 视图大小
    /// - Returns: UIVIew
    class func initViewBy(c:UIColor,xy:CGPoint,size:CGSize) -> UIView {
        let view = UIView()
        view.backgroundColor = c
        view.frame = CGRect(origin: xy, size: size)
        return view
    }
}
extension UILabel {
    
    /// 创建UILabel
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - def: 默认文字
    /// - Returns: UILabel
    class func initLayBy(fontSize:CGFloat,def:String) -> UILabel {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: fontSize)
        lab.text = def
        lab.textAlignment = NSTextAlignment.center
        return lab
    }
}
extension UITableView{
    
    /// UITableView 配置常用属性
    /// - Parameters:
    ///   - frame: -
    ///   - style: -
    /// - Returns: -
    class func initTableViewBy(frame:CGRect,style:UITableView.Style) ->UITableView{
        let tableView = UITableView(frame: frame, style: style)
        #warning("到时候修改成APP需要的颜色")
        tableView.backgroundColor = .white
        tableView.separatorColor = .red
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.bounces = true
        tableView.estimatedRowHeight = 200
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        return tableView
        
    }
}
extension UIViewController {
    
    /// 返回当前控制器
    /// - Returns: 当前控制器
   class func getCurrentVC() -> UIViewController {
        let rootViewController:UIViewController  = (UIApplication.shared.keyWindow?.rootViewController)!
        
        let currentVC:UIViewController = self.getCurrentVCFrom(rootVC: rootViewController)
        
        return currentVC
    }
   class func getCurrentVCFrom(rootVC:UIViewController) -> UIViewController {
        var currentVC:UIViewController
        if (rootVC.presentedViewController != nil) {
            currentVC = rootVC.presentedViewController!
        }
        if rootVC .isKind(of: UITabBarController.self) {
            let tabbar:UITabBarController = rootVC as!UITabBarController
            
            currentVC = self.getCurrentVCFrom(rootVC: tabbar.selectedViewController!)
        }else if rootVC .isKind(of: UINavigationController.self){
            let nav:UINavigationController = rootVC as!UINavigationController
            currentVC = self.getCurrentVCFrom(rootVC: nav.visibleViewController!)
        }else{
            currentVC = rootVC
        }
        
        return currentVC
    }
}

extension String{
    
    /// 返回字符串长度
    /// - Returns: 字符串长度
     func length()->(Int) {
        return self.count
    }
}

extension UIColor{
    
   class func colorWithHexString(_ hexString:String) -> UIColor {
         let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
               let scanner = Scanner(string: hexString)
                
               if hexString.hasPrefix("#") {
                   scanner.scanLocation = 1
               }
                
               var color: UInt32 = 0
               scanner.scanHexInt32(&color)
                
               let mask = 0x000000FF
               let r = Int(color >> 16) & mask
               let g = Int(color >> 8) & mask
               let b = Int(color) & mask
                
               let red   = CGFloat(r) / 255.0
               let green = CGFloat(g) / 255.0
               let blue  = CGFloat(b) / 255.0
                
              return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        
    }
//    func colorWithHexString(hex:UInt32) -> UIColor {
//        let r = (hex >> 16) & 0xFF
//        let g = (hex >> 8) & 0xFF
//        let b = (hex) & 0xFF
//
//        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
//
    //    }
    /// 随机颜色
    /// - Returns: 随机颜色
    class func arc4Color()->UIColor {
        
        return UIColor.init(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 1)
    }
}
