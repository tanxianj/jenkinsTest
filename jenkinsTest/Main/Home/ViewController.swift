//
//  ViewController.swift
//  jenkinsTest
//
//  Created by swift on 2021/4/19.
//

import UIKit
//import Kingfisher

class ViewController: UIViewController,SwiftProtocol {
    var imgUrlArray:NSArray = []
    var successArray = [String]()
    var errorArray = [String]()
    
    
    @IBOutlet weak var testLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let jsonPath = Bundle.main.path(forResource: "imageUrl", ofType: "json")
        let data = NSData.init(contentsOfFile: jsonPath!)
        let jsonDic:NSDictionary = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        self.imgUrlArray = jsonDic.object(forKey: "imgUrl") as! NSArray;
        
    }
    
    /// 请求
    /// - Parameter sender: --
    @IBAction func requestBtnAction(_ sender: UIButton) {
        //MARK:清空成功和失败数组的内容
        
        self.successArray.removeAll()
        self.errorArray.removeAll()
        
        //MARK:遍历测试请求
        for  url in self.imgUrlArray {
            
            //MARK:开始请求
            HTTPSessionManager.shareInstance.requseDatas(type: .get, URLString: url as! String, paramares: nil) { (success, tmpUrl) in
                //MARK:请求成功 加入成功数组
                if success {
                    self.successArray.append(tmpUrl)
                }else{
                //MARK:请求失败 加入失败数组
                    self.errorArray.append(tmpUrl)
                }
            }
            //MARK:休眠1s
            Thread.sleep(forTimeInterval: 1.0)
        }
        //MARK:提交操作
        
        //<#code#>
    }
    
    /// 打印
    /// - Parameter sender: --
    @IBAction func logBtnAction(_ sender: UIButton) {
        print("请求成功 数组 \(self.successArray) \n 数组长度 \(self.successArray.count)")
        print("请求失败 数组 \(self.errorArray) \n 数组长度 \(self.errorArray.count)")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:个人测试
    @IBAction func gotoTest(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "testView") as! ProtocolViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //MARK:协议回调
    func thisITextfield(str: String?) {
        let tmpstr = (str!.count != 0) ? str : "未设置"
        self.testLab.text = tmpstr
        self.title = tmpstr
        print(tmpstr!)
        
    }
    
}

