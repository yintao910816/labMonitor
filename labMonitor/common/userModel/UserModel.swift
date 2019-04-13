//
//  UserModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

@objcMembers
class UserModel: NSObject {

    var userid : String?
    var hospitalcode : String?
    var hospitalname : String?
    var username : String?
    var pwd : String?
    var isuse : NSNumber?
    
    var phonenum : String?
    var devicetoken : String?
    var devicetype: String?
    
    var hospitalEquipmentType : NSArray?
    
    var token: String?
    
    convenience init(dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }
    
}
