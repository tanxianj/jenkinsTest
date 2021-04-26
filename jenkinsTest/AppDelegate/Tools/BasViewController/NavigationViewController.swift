//
//  NavigationViewController.swift
//  Swift学习
//
//  Created by 谭显敬 on 2020/10/25.
//  Copyright © 2020 谭显敬 联系QQ :1079139185 Wx:xj1079139185. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController,UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
//        UINavigationBar.appearance().backgroundColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.white
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black, .font : UIFont.systemFont(ofSize: 18), /*.backgroundColor:UIColor.red*/]
        // Do any additional setup after loading the view.
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
