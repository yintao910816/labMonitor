//
//  Version.swift
//  labMonitor
//
//  Created by 尹涛 on 2018/9/14.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import Foundation

class VersionModel: NSObject {

    var id: String = ""
    var code: String = ""
    var filename: String = ""
    // 版本名称
    var versionname: String = ""
    // 版本名称
    var info: String = ""
    // 1强制更新 2不强制更新
    var forceUpdate: Int = 2
    // 1强制更新 2不强制更新
    var date: String = ""
    
    convenience init(dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }

}
