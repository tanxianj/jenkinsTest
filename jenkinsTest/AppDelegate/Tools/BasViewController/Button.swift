//
//  Button.swift
//  Swift学习
//
//  Created by 谭显敬 on 2020/10/25.
//  Copyright © 2020 谭显敬 联系QQ :1079139185 Wx:xj1079139185. All rights reserved.
//

import UIKit

class Button: UIButton {
    var buttonAction:(() -> Void)?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func addBlock(callblock:@escaping (()->(Void))){
        self.buttonAction = callblock
    }
    

}
