//
//  DESUtil.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/23.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit
import CommonCrypto

let options = kCCOptionECBMode|kCCOptionPKCS7Padding
let cypher = SymmetricCryptor(algorithm: .des, options: options)

class DESUtil: NSObject {
    
    
    /// DES-ECB加密
    /// - Parameters:
    ///   - clearText: 加密字符串
    ///   - key: key
    /// - Returns: 加密后的字符串
    class func encryptUseDES(clearText:String,key:String) ->String{
        var ciphertext:String?
        do{
            let data = try cypher.crypt(string: clearText, key: key)
            ciphertext = data.base64EncodedString()
        }catch{
            ciphertext = "加密失败"
        }
       
        return ciphertext!
        
    }
    class func decryptUseDES(plainText:String,key:String)->String {
        var cleartext:String?
        /* 解密可用方式 1
         
         if let cipherdata = key.data(using: .utf8), let data = Data(base64Encoded: plainText) {
             var numBytesDecrypted: size_t = 0
             var result = Data(count: data.count)
             
             let err = result.withUnsafeMutableBytes {resultBytes in
                 data.withUnsafeBytes {dataBytes in
                     cipherdata.withUnsafeBytes {keyBytes in
                         CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmDES), CCOptions(kCCOptionECBMode|kCCOptionPKCS7Padding), keyBytes, kCCKeySizeDES, nil, dataBytes, data.count, resultBytes, data.count, &numBytesDecrypted)
                     }
                 }
             }
             guard err == CCCryptorStatus(kCCSuccess) else {
                 print("Decryption failed! Error: \(err.description)")
                 return "解密失败!"
             }
             cleartext = String(data: result, encoding: .utf8) ?? "解密失败!"
             
             
         }
         */
        /* 方式2*/
        do{
            let data = try cypher.decrypt(Data.init(base64Encoded: plainText)!, key: key)
            cleartext = String(data: data, encoding: .utf8)
        }catch{
            cleartext = "解析失败"
        }
        return cleartext!
    }
    
}
extension DESUtil{
    
    /// 加密参数
    /// - Parameter paramaresDic: 参数
    /// - Returns: 加密后 后台需要的字典
    class func paramaresToString(_ paramaresDic:[String:Any]?) ->[String:String]! {
        let string = paramaresDic?.toJsonString()
        var param = DESUtil.encryptUseDES(clearText: string!, key: APPKey)
        //这是因为 后台会屏蔽+ 所以替换吃URL编码 （swift编码不会转义+ ）
        param = param.replacingOccurrences(of: "+", with: "%2b")
        let dic = ["param":param]
        return dic
    }
    
    /// 解密返回值
    /// - Parameter result: 服务器返回
    /// - Returns: 解密后的Json
    class func resultToJson(_ result:[String:Any]?) ->[String:Any]!{
        let string = DESUtil.decryptUseDES(plainText: result!["re"] as! String, key: APPKey)
       let resultDic =  string.toDictionary()
        return resultDic
    }
}
