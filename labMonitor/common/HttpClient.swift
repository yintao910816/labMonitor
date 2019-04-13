//
//  HttpClient.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation
import AFNetworking
import SVProgressHUD

class HttpClient {
    
    lazy var HCmanager : AFHTTPSessionManager = {
        let mg = AFHTTPSessionManager.init()
        mg.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json",
                                                                  "text/json",
                                                                  "text/javascript",
                                                                  "text/html",
                                                                  "text/plain") as? Set<String>
        mg.requestSerializer.timeoutInterval = 10
//        mg.securityPolicy = AFSecurityPolicy.init(pinningMode: AFSSLPinningMode.none)
//        mg.securityPolicy.allowInvalidCertificates = true
//        mg.securityPolicy.validatesDomainName = false
        mg.requestSerializer = AFJSONRequestSerializer.init()
        
        return mg
    }()
    
    
    // 设计成单例
    static let shareIntance : HttpClient = {
        let tools = HttpClient()
        return tools
    }()
    
    // 定义闭包别名
    typealias HttpRequestCompleted = (_ result : Any, _ ccb : CommonCallBack)->()
}

extension HttpClient {
    
    
    func POST(_ URLString : String, parameters : NSDictionary?, callBack : @escaping HttpRequestCompleted) {
        let parameDic = addCommonParameters(parameters)
        POST(URLString, requestKey : nil, parameters : parameDic, callBack : callBack)
    }
    
    func GET(_ URLString : String, parameters : NSDictionary?, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        GET(URLString, requestKey : nil, parameters : parameDic, callBack : callBack)
    }
    
    func GET(_ URLString : String, requestKey : String?, parameters : NSDictionary, callBack : @escaping HttpRequestCompleted){
        
        HCPrint(message: URLString)
        HCPrint(message: parameters)
        
        let url = URLString == HC_LOGIN ? URLString : URLString + "?token=\(UserManager.shareIntance.currentUser?.token ?? "")"

        HCmanager.get(url, parameters: parameters, progress: { (progress) in
            //
        }, success: { [weak self](task : URLSessionDataTask, responseObject : Any?) in
            
            HCPrint(message: URLString)
            HCPrint(message: responseObject)
            
            let ccb = CommonCallBack.init()
            
            let resDic = responseObject as? NSDictionary
            
            guard let dic = resDic else{
                callBack("", ccb)
                return
            }
            
            if let tempCode = dic.value(forKey: "code") as? NSInteger{
                ccb.code = tempCode
            }
            
            self?.dealWithCode(code: ccb.code)
            
            if let tempS = dic.value(forKey: "message") as? String{
                ccb.msg = tempS
            }
            
            ccb.result = dic.value(forKey: "result")
            
            callBack(responseObject, ccb)
            
        }) { ( task : URLSessionDataTask?, error : Error) in
            
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            
            HCPrint(message: URLString)
            HCPrint(message: error)
            
            callBack("", ccb)
        }

        
    }
    


    
    
    func POST(_ URLString : String, requestKey : String?, parameters : NSDictionary, callBack : @escaping HttpRequestCompleted){
        
        HCPrint(message: URLString)
        HCPrint(message: parameters)
        
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

//        do {
//            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//            let str = String(data: data, encoding: String.Encoding.utf8)
//
//        } catch {
//
//        }
        let url = URLString == HC_LOGIN ? URLString : URLString + "?token=\(UserManager.shareIntance.currentUser?.token ?? "")"
        HCmanager.post(url, parameters: parameters, progress: { (progress) in
            //
        }, success: { [weak self](task : URLSessionDataTask, responseObject : Any) in
            HCPrint(message: URLString)
            HCPrint(message: responseObject)
            
            let ccb = CommonCallBack.init()
            
            let resDic = responseObject as? NSDictionary
            
            guard let dic = resDic else{
                callBack("", ccb)
                return
            }
            
            if let tempCode = dic.value(forKey: "code") as? NSInteger{
                ccb.code = tempCode
            }
            
            self?.dealWithCode(code: ccb.code)
            
            if let tempS = dic.value(forKey: "message") as? String{
                ccb.msg = tempS
            }
            
            ccb.result = dic.value(forKey: "result")
            
            callBack(responseObject, ccb)
            
        }) { [weak self](task : URLSessionDataTask?, error : Error) in
            
            
            HCPrint(message: error)
            
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if (self?.HCmanager.reachabilityManager.isReachable)! {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }

    }
    
    func dealWithCode(code : NSInteger){
        
        HCPrint(message: code)
        
        if code == 401 {
            UserManager.shareIntance.logout(showMsg: true)
        }
    
    }
    
    
    func addCommonParameters(_ param : NSDictionary? ) -> NSDictionary{

        var dic = NSMutableDictionary.init()
        if let param = param{
            dic = NSMutableDictionary.init(dictionary: param)
        }
        
        dic["token"] = UserManager.shareIntance.currentUser?.token ?? ""
        dic["deviceType"] = "iOS"
        
        let infoDic = Bundle.main.infoDictionary      //CFBundleIdentifier
        let version = infoDic?["CFBundleShortVersionString"] as! String
        dic["version"] = version
        
        let sysVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.modelName
        let info = sysVersion + "," + deviceModel + ",apple," + version
        dic["deviceInfo"] = info
        
        return dic as NSDictionary
    }
    
    
    func cancelAllRequest(){
        for t in HCmanager.tasks {
            t.cancel()
        }
    }
}


extension HttpClient {
    //版本检测
    func CheckVersion(){
        
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as! NSString
        HCPrint(message: currentVersion)

        let localArray = currentVersion.components(separatedBy: ".")
        
        let urlS = "http://itunes.apple.com/lookup?id=" + kAppID
        
        HCmanager.get(urlS, parameters: nil, progress: { (progress) in
            //
        }, success: { (task, any) in
            
            let response = any as! NSDictionary
            let arr = response["results"] as! NSArray
            let dic = arr[0] as! NSDictionary
            let versionS = dic["version"] as! NSString
            let trackViewUrlS = dic["trackViewUrl"] as! String
            
            HCPrint(message: versionS)
            let versionArray = versionS.components(separatedBy: ".")
            
            for i in 0..<versionArray.count{
                if i > localArray.count - 1 {
                    let alertController = UIAlertController(title: "新版上线",
                                                            message: "马上更新吗？如果更新失败，请在iTunes界面点击下方的更新按钮，进行手动更新", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "马上更新", style: .default, handler: {(action)->() in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: trackViewUrlS)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL.init(string: trackViewUrlS)!)
                        }
                    })
                    
                    alertController.addAction(okAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                let verInt = versionArray[i] as! NSString
                let locInt = localArray[i] as! NSString
                if verInt.intValue > locInt.intValue {
                    let alertController = UIAlertController(title: "新版上线",
                                                            message: "马上更新吗？如果更新失败，请在iTunes界面点击下方的更新按钮，进行手动更新", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "马上更新", style: .default, handler: {(action)->() in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: trackViewUrlS)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL.init(string: trackViewUrlS)!)
                        }
                    })
                    
                    alertController.addAction(okAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }else if verInt.intValue < locInt.intValue {
                    return
                }
            }
            
        }) { (task, error) in
            HCPrint(message: "版本检测出错！")
        }
    }
}



