//
//	APPResultModel.swift

//  创建于 26/4/2021
//	Copyright © 2021. All rights reserved.


import Foundation

struct APPResultModel{

	var data : String!
	var msg : String!
	var status : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		data = dictionary["data"] as? String
		msg = dictionary["msg"] as? String
		status = dictionary["status"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			dictionary["data"] = data
		}
		if msg != nil{
			dictionary["msg"] = msg
		}
		if status != nil{
			dictionary["status"] = status
		}
		return dictionary
	}

}