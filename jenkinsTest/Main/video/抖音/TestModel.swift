//
//	TestModel.swift

//  创建于 24/4/2021
//	Copyright © 2021. All rights reserved.


import Foundation

struct TestModel{

	var pwd : String!
	var username : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		pwd = dictionary["pwd"] as? String
		username = dictionary["username"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if pwd != nil{
			dictionary["pwd"] = pwd
		}
		if username != nil{
			dictionary["username"] = username
		}
		return dictionary
	}

}