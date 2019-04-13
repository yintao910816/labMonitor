//
//  HttpRequestManager.swift
//  
//
//  Created by pg on 2017/4/24.
//
//

import Foundation

class HttpRequestManager {
    
    // 设计成单例
    static let shareIntance : HttpRequestManager = {
        let tools = HttpRequestManager()
        return tools
    }()
    
    //登录
    func HC_login(account : String, password : String, devicetoken : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["username" : account, "pwd" : password, "devicetoken" : devicetoken])
        HttpClient.shareIntance.POST(HC_LOGIN, parameters: dic) { (result, ccb) in
            if ccb.success(){
                let dic = ccb.result as! [String : Any]
                
                let m = UserModel.init(dic: dic)
                UserDefaults.standard.set(dic, forKey: kUserDic)
                UserManager.shareIntance.currentUser = m
                callback(true, "登录成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }

    // 退出登录
    func HC_login_out(callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.POST(HC_LOGIN_OUT, parameters: nil) { (result, ccb) in
            if ccb.success(){
                callback(true, "登出成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    func HC_update_deviceToken(deviceToken: String, uid: String, callback : @escaping (Bool, String)->()) {
        HttpClient.shareIntance.POST(HC_UPDATE_DEVICETOKEN, parameters: ["userid": uid, "devicetoken": deviceToken]) { (ret, ccb) in
            if ccb.success(){
                callback(true, "更新deviceToken成功")
            }else{
                callback(false, "更新deviceToken失败")
            }
        }
    }
    
    // 检查版本更新
    func HC_check_version(callback : @escaping (Bool, VersionModel?)->()) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

        HttpClient.shareIntance.GET(HC_CHECK_VERSION, parameters: ["versionId": version]) { (result, ccb) in
            if ccb.code != 200, let dic = ccb.result as? [String : Any]{
                // 与当前版本信息不一致
                let m = VersionModel.init(dic: dic)
                callback(false, m)
            }else {
                HCPrint(message: "当前版本已是最新版本")
                callback(true, nil)
            }
        }
    }

    //获取验证码
    func HC_validateCode(userphone : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["phonenum" : userphone])
        HttpClient.shareIntance.GET(HC_VALIDATECODE, parameters: dic) { (result, ccb) in
            if ccb.success(){
                callback(true, "获取成功")
            }else{
                callback(false, "获取失败")
            }
        }
    }
    
    //修改密码
    func HC_modifyPassword(UserId : String, newpassword : String, messagecode  : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["userid" : UserId, "pwd" : newpassword, "code" : messagecode])
        HttpClient.shareIntance.POST(HC_MODIFY_PASSWORD, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                callback(true, "修改成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    //修改手机号
    func HC_modifyPhone(newphonenum : String, UserId : String, messagecode  : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["phonenum" : newphonenum, "userid" : UserId, "code" : messagecode])
        HttpClient.shareIntance.POST(HC_MODIFY_PHONE, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                callback(true, "修改成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
//    func HC_deviceToken(deviceToken : String, callback : @escaping (Bool, String)->()){
//        let dic = NSDictionary.init(dictionary: ["deviceToken" : deviceToken])
//        HttpClient.shareIntance.POST(HC_DEVICE_TOKEN, parameters: dic) { (result, ccb) in
//            HCPrint(message: result)
//            if ccb.success(){
//                callback(true, "上传成功")
//            }else{
//                callback(false, ccb.msg)
//            }
//        }
//    }
    
    
    
    func HC_readedMessage(Instrument_No : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["Instrument_No" : Instrument_No])
        HttpClient.shareIntance.POST(HC_READED, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                callback(true, "设置成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
    
//    Disposecode (1 : 30分钟后处理  2 ： 1小时后处理  48 ： 24小时后处理 4 不再推送)
    func HC_dealWithMessage(Instrument_No : String, Disposecode : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["instrumentparamconfigNO" : Instrument_No, "type" : Disposecode])
        HttpClient.shareIntance.POST(HC_DEAL_MESSAGE, parameters: dic) { (result, ccb) in
            HCPrint(message: result)
            if ccb.success(){
                callback(true, "处理成功")
            }else{
                callback(false, ccb.msg)
            }
        }
    }
    
 
}



