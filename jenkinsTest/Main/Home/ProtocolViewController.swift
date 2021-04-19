//
//  ProtocolViewController.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/19.
//

import UIKit
protocol SwiftProtocol {
    
    func thisITextfield(str:String?) -> Void
}
class ProtocolViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var delegate:SwiftProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "协议传值测试"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func popBtnAction(_ sender: Any) {
        guard  let str = self.textField.text else {
            return
        }
//        guard str.count > 0 else {
//            print("请输入文字")
//            return
//        }
        self.delegate?.thisITextfield(str: str)
        self.navigationController?.popViewController(animated: true)
        
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
