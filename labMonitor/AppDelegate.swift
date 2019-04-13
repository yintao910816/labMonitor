//
//  AppDelegate.swift
//  com.huchuang.labMonitor
//
//  Created by huchuang on 2018/3/26.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var Login = false
    
    lazy var space : (topSpace : CGFloat, bottomSpace : CGFloat) = {
        let s = HC_getTopAndBottomSpace()
        return s
    }()
    
    // 设计成单例
    static let shareIntance : AppDelegate = {
        let share = AppDelegate()
        return share
    }()
    
    var defaultViewController : UIViewController {
        
        let dic = UserDefaults.standard.value(forKey: kUserDic)
        var loginNav : UIViewController!
        if let dic = dic{
            UserManager.shareIntance.currentUser = UserModel.init(dic: dic as! [String : Any])
            Login = true
        }else{
            
            
//            let dic = [
//                "UserId" : "admin",
//                "isuse" : true,
//                "Pwd":"123",
//                "username":"admin",
//                "HospitalName":"互创联合",
//                "token":"0278b1c1b26b31864aad56cb6470d851997640f650a9d5d38cdcfede7d65fb17e85ae4f4ba8a644c",
//                "userphone":"17786499503",
//                "HospitalCode":"H0004",
//                "电源":"0006",
//                "code":"200"
//                ] as [String : Any]
//
//            UserManager.shareIntance.currentUser = UserModel.init(dic: dic)
//            UserDefaults.standard.set(dic, forKey: kUserDic)
//            Login = true
            
            Login = false
            loginNav = BaseNavigationController.init(rootViewController: LoginViewController())
        }
        return Login ? MainTabBarController() : loginNav
        
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
//        if UserDefaults.standard.string(forKey: kDeviceToken) == nil {
//            UserDefaults.standard.set(UIDevice.current.identifierForVendor?.uuidString, forKey: kDeviceToken)
//        }
        
        let rect = UIScreen.main.bounds
        window = UIWindow.init(frame: rect)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        UMeng(launchOptions: launchOptions)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            HttpRequestManager.shareIntance.HC_check_version { (flag, model) in
                if flag == false {
                    NSObject.alert(title: "发现新版本", message: model?.info ?? "", cancleTitle: "取消", okTitle: "去更新", callBackOK: {
                        let urlString = "itms-apps://itunes.apple.com/app/id\(kAppID)"
                        if let url = URL(string: urlString) {
                            //根据iOS系统版本，分别处理
                            if #available(iOS 10, *) {
                                application.open(url, options: [:], completionHandler: { (success) in })
                            } else {
                                application.openURL(url)
                            }
                        }
                    })
                }
            }
        }
        
        return true
    }
    
    func UMeng(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        
        UMConfigure.initWithAppkey(KUMengKey, channel: "AppStore")

        if #available(iOS 10.0, *) {
            let entity = UMessageRegisterEntity.init()
            entity.types = Int(UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.badge.rawValue | UNAuthorizationOptions.sound.rawValue)
            UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (bool, err) in
                if bool == true{
                    HCPrint(message: "UMessage  true")
                }else{
                    HCPrint(message: "UMessage  false")
                    
                    let alert = UIAlertController(title: "消息提醒", message: "您的消息开关没有打开，可能会错失重要消息提醒", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) -> Void in
                        
                    }))
                    alert.addAction(UIAlertAction(title: "马上设置", style: .default, handler: { (_) -> Void in
                        let settingUrl = URL.init(string: UIApplicationOpenSettingsURLString)
                        if UIApplication.shared.canOpenURL(settingUrl!){
                            UIApplication.shared.openURL(settingUrl!)
                        }
                    }))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
//        Token Registration
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        NetworkStatusTool.NetworkingStatus()
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        HCPrint(message: url.absoluteString)
        
        return true
    }
    
}



extension AppDelegate : UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let nsdataStr = NSData.init(data: deviceToken)
        let s = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        HCPrint(message: "友盟devicetoken --- \(s)")
        UserDefaults.standard.set(s, forKey: kDeviceToken)

        if UserManager.shareIntance.currentUser?.token != nil{
            //已登录
            HttpRequestManager.shareIntance.HC_update_deviceToken(deviceToken: s, uid: UserManager.shareIntance.currentUser!.userid!) { (ret, msg) in
                
            }
        }
        
    }
    
    //收到远程推送消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        self.receiveRemoteNotificationForbackground(userInfo: userInfo)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let information = response.notification.request.content.userInfo
        HCPrint(message: information)
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于后台时的本地推送接受
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let information = notification.request.content.userInfo
        HCPrint(message: information)
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于前台时的本地推送接受
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    
    func receiveRemoteNotificationForbackground(userInfo : [AnyHashable : Any]){
        
//        [AnyHashable("equipmentTypeNo"): 0001,
//         AnyHashable("content"): [4号培养箱温度]的温度异常，异常温度为：21.31℃，请尽快查看;,
//        AnyHashable("equipmentNo"): E1004,
//        AnyHashable("instrumentNo"): S2004,
//        AnyHashable("inputDateTime"): ,
//        AnyHashable("p"): 0,
//        AnyHashable("equipmentName"): 4号培养箱,
//        AnyHashable("title"): 培养箱异常！,
//        AnyHashable("aps"): {
//            alert = "\U6d88\U606f\U63a8\U9001";
//            badge = 0;
//            sound = default;
//        },
//        AnyHashable("equipmentTypeName"): 培养箱,
//        AnyHashable("d"): uucprqk152238747640000]
        
        HCPrint(message: "收到推送消息：\(userInfo)")
        
        let title = userInfo["equipmentName"] as? String ?? "title"
        let content = userInfo["content"] as? String ?? "content"
        let time = userInfo["inputDateTime"] as? String ?? ""
        let id = userInfo["instrumentNo"] as? String ?? ""
        
        let alertVC = AlertViewController()
        alertVC.titleL.text = title
        alertVC.contentL.text = content
        alertVC.timeL.text = time
        alertVC.Instrument_No = id
        
        alertVC.modalPresentationStyle = .custom
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: false, completion: nil)
        
    }
    
}


