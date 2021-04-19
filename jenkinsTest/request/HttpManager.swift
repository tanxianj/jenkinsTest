//
//  HttpManager.swift
//  jenkinsTest
//
//  Created by swift on 2021/4/19.
//

import UIKit
import Alamofire

private let httpShareInstance = HTTPSessionManager()
enum MothodType{
    case get
    case post
}

class HTTPSessionManager:NSObject {
    class var shareInstance:HTTPSessionManager{
        
        return httpShareInstance
    }
}
extension HTTPSessionManager{
    func requseDatas(type:MothodType,URLString:String,paramares:[String:Any]?,callBlock:@escaping(_ response:Bool,_ URL:String) ->Void) -> Void {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: paramares, encoding: URLEncoding.default, headers: nil).responseData { (respinseJson) in
            if respinseJson.result.isSuccess  {
//                print("请求成功")
                callBlock(true,URLString)
                return
            }else{
//                print("\(URLString) \n 请求失败")
                callBlock(false,URLString)
                return
            }
            
        }
    }
}
