//
//	Permission.swift
//
//	Create by X140Yu Zhao on 11/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Permission {

    var admin: Bool!
    var pull: Bool!
    var push: Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(_ dictionary: [String:Any]) {
        admin = dictionary["admin"] as? Bool
        pull = dictionary["pull"] as? Bool
        push = dictionary["push"] as? Bool
    }
    
}
