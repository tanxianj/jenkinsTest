//
//  HttpManager.swift
//  jenkinsTest
//
//  Created by swift on 2021/4/19.
//

import UIKit
import Alamofire

private let httpShareInstance = HTTPSessionManager()
typealias  resultCallBlock = (_ model:APPResultModel)->Void
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
    
    func requseDatas(type:MothodType,URLString:String,paramares:[String:Any]?,callBlock:@escaping resultCallBlock) -> Void {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        DefaultRequest(URLString: URLString, method: method, parameters: paramares, callBlock: callBlock)
    }
    func requseDatasWithList(type:MothodType,URLString:String,pageNum:Int,paramares:[String:Any]?,callBlock:@escaping resultCallBlock) -> Void {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        /// 把需要传 pageNum 和 pageSize 的地方封装下 这样不用每次都传
        var page:[String : Any] = ["pageNum":pageNum,"pageSize":"20"]
        
        for (key,value) in paramares!.reversed() {
            page[key] = value
        }
        
        DefaultRequest(URLString: URLString, method: method, parameters: paramares, callBlock: callBlock)
    }
    
    /// 默认请求
    /// - Parameters:
    ///   - URLString: -
    ///   - method: -
    ///   - parameters: -
    ///   - callBlock: 返回模型
    fileprivate func DefaultRequest(URLString:String,method:HTTPMethod,parameters:[String:Any]?,callBlock:@escaping resultCallBlock){
        
        Alamofire.request(URLString, method: method, parameters: DESUtil.paramaresToString(parameters), encoding: URLEncoding.default, headers: nil).responseJSON { [self] (respinseJson) in
            if respinseJson.result.isSuccess  {
                print("请求成功 \(respinseJson.result.value ?? "aaa")")
                let result:Dictionary = respinseJson.result.value! as! [String : Any]

                let model = APPResultModel.init(fromDictionary: DESUtil.resultToJson(result))
                handleRespond(data: model, error: nil, callBlock: callBlock)
                return
            }else{
                print("\(URLString) \n 请求失败")
                handleRespond(data: nil, error: respinseJson.result.error, callBlock: callBlock)
                return
            }
            
        }
        
    }
    fileprivate func handleRespond(data:APPResultModel?,error:Error?,callBlock:resultCallBlock){
        guard error != nil else {
            /*
             var data : String!
             var msg : String!
             var status : Int!
             */
            let model = APPResultModel(fromDictionary: ["data":"","msg":"服务器开小差，请稍后再试","status":-1])
            
            callBlock(model)
            return
        }
        //MARK:结果处理
        
        switch data?.status {
        case 0:
            
            break
        case 1://成功
            
            callBlock(data!)
            break
        default:
            
            break
        }
        
    }
    
}
