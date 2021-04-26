//
//  BaseViewController.swift
//  Swift学习
//
//  Created by 谭显敬 on 2020/10/25.
//  Copyright © 2020 谭显敬 联系QQ :1079139185 Wx:xj1079139185. All rights reserved.
//

import UIKit
typealias block = () ->()?
enum itemType{
    case left
    case right
}
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let block = {(btnAction)->()}
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.colorWithHexString("F5F6F7")
    }
    
    /// 设置导航栏 相关
    /// - Parameters:
    ///   - barTintColor: 背景颜色
    ///   - titleColor: title 颜色
    ///   - fontSize: title 字体大小
    func Txj_Navigation(barTintColor:UIColor,titleColor:UIColor,fontSize:CGFloat){
        self.navigationController?.navigationBar.barTintColor = barTintColor;
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:titleColor , .font:UIFont.systemFont(ofSize: fontSize)]
    }
    typealias itemAction = ()->()?
    func txj_navigationItem(type:itemType,title:String?=nil,imageName:String?=nil, titleColor:UIColor?=nil,itemAction:itemAction?=nil) -> UIBarButtonItem{
        let btn = Button.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 64, height: 44)
        if imageName == "return" {
            
        }
        if let tmpTitle = title {
            btn.setTitle(tmpTitle, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            if titleColor != nil {
                btn.setTitleColor(titleColor, for: .normal)
            }else{
                btn.setTitleColor(UIColor.black, for: .normal)
            }
            switch type {
            case .left:
                btn.contentHorizontalAlignment = .left
            //                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            case .right:
                btn.contentHorizontalAlignment = .right
                //                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            }
        }
        if let tmpImageName = imageName  {
            
            btn.setImage(UIImage.init(named: tmpImageName), for: .normal)
            switch type {
            case .left:
                btn.contentHorizontalAlignment = .left
            //                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            case .right:
                btn.contentHorizontalAlignment = .right
                //                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            }
        }
        if let action = itemAction {
            btn.addBlock {
                action()
            }
        }
        
        btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: btn)
    }
    @objc func BarButtonItemAction(btn:Button){
        if let action = btn.buttonAction  {
            action()
        }else{
            let rootvc:UIViewController = UIViewController.getCurrentVC()
            rootvc.navigationController?.popViewController(animated: true)
        }
    }
    @objc func btnAction(btn:Button) {
        if let action = btn.buttonAction  {
            action()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
