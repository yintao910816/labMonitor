//
//  UserManager.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/25.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class UserManager: NSObject {
    
    var currentUser : UserModel?
    
    static let shareIntance : UserManager = {
        let share = UserManager()
        return share
    }()
    
    
    func setUserPhone(phone : String){
        let dic = UserDefaults.standard.value(forKey: kUserDic) as? [String : Any]
        if var dic = dic{
            dic["phonenum"] = phone
            UserDefaults.standard.set(dic, forKey: kUserDic)
        }
        currentUser?.phonenum = phone
    }
    
    
    func logout(showMsg: Bool = false){
        if showMsg == true {
            NSObject.alert(title: "提示", message: "您的账号已在其它地方登录", okTitle: "去登录") { [unowned self] in
                self.toLoginout()
            }
        }else {
            toLoginout()
        }
    }
    
    private func toLoginout() {
        HttpClient.shareIntance.cancelAllRequest()
        
        //清理缓存
        if #available(iOS 9.0, *) {
            let types = WKWebsiteDataStore.allWebsiteDataTypes()
            let dateForm = Date.init(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateForm, completionHandler: {
                HCPrint(message: "clear cache")
            })
        }
        
        //清空当前用户
        UserManager.shareIntance.currentUser = nil
        
        //注销推送
        //        UMessage.unregisterForRemoteNotifications()
        
        //清空用户信息
        UserDefaults.standard.removeObject(forKey: kUserDic)
        UserDefaults.standard.removeObject(forKey: kPassWord)
        
        //跳转登录界面
        UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController.init(rootViewController: LoginViewController())
    }
    
}
