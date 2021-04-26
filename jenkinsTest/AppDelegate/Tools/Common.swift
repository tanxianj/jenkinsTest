//
//  Common.swift
//  简单计算器
//
//  Created by 谭显敬 on 2021/4/13.
//

import UIKit
let APPKey = "12344321"
//屏幕宽高
let KScreenW = UIScreen.main.bounds.width
let KScreenH = UIScreen.main.bounds.height

//KeyWindow
let Keywindow = UIApplication.shared.keyWindow

//判断是否是Iphone
let kIsIphone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)

//判断是否为刘海屏
let KisIphoneX = Bool(KScreenW >= 375.0 && KScreenH >= 812.0 && kIsIphone)
//导航栏高度
let KNavigationH = CFloat(KisIphoneX ? 88.0 : 64.0)

//状态栏高度
let KStatusBarH  = CGFloat(KisIphoneX ? 44.0 : 20.0)

//tabbar高度
let KtabbarH = CGFloat(KisIphoneX ? (49.0+34.0) : 49.0)

/// 一像素
//let KonePx = CGFloat(1.0/UIScreen.main.bounds)

//自定义RGB 颜色

func RGBColor(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

//字号 以刘海屏为基础

func customFont(fontSize:CGFloat) -> UIFont {
    // 刘海屏
    guard KScreenH <= 736 else {
        return UIFont.systemFont(ofSize: fontSize)
    }
    // 5.5
    guard KScreenH == 736 else {
        return UIFont.systemFont(ofSize: fontSize - 2)
    }
    // 4.7
    guard KScreenH >= 736 else {
        return UIFont.systemFont(ofSize: fontSize - 4)
    }
    
    return UIFont.systemFont(ofSize: fontSize)
}








