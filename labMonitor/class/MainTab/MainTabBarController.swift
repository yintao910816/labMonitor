//
//  MainTabBarController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override var childViewControllerForStatusBarStyle: UIViewController?{
        get {
            return self.selectedViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(childControllerName: "WebViewController", title: "监控", normalImage: "监控")
        addChildViewController(childControllerName: "WebViewController", title: "警报", normalImage: "报警")
        addChildViewController(childControllerName: "WebViewController", title: "设备", normalImage: "设备")

        self.tabBar.tintColor = kDefaultThemeColor
        self.tabBar.isTranslucent = false
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        if #available(iOS 10.0, *) {
//            let content = UNMutableNotificationContent.init()
//            content.title = "这是标题"
//            content.subtitle = "这是子标题"
//            content.body = "这是内容"
//            content.badge = NSNumber.init(value: 3)
//            content.userInfo = [
//                "equipmentTypeName": "培养箱" ,
//                "equipmentTypeNo": "0001" ,
//                "equipmentName": "1号培养箱" ,
//                "inputDateTime": "1474537178000" ,
//                "content": "1号培养箱报警信号出现异常，请尽快查看" ,
//                "equipmentNo": "设备编号" ,
//                "instrumentNo": "探头编号 " ,
//            ]
//            content.sound = UNNotificationSound.default()
//
//
//            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3, repeats: false)
//            let identifier = "test1"
//            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request) { (err) in
//                HCPrint(message: err)
//            }
//        }
//
//    }

    
    private func addChildViewController(childControllerName : String, title : String, normalImage : String) {
        
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            HCPrint(message: "clsName false")
            return
        }
        
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)

        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            HCPrint(message: "UIViewController false")
            return
        }

        // 3.通过Class创建对象
        let childController = clsType.init()
        
        // 设置TabBar和Nav的标题
        childController.title = title
        
        childController.tabBarItem.image = UIImage(named: normalImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: normalImage + "_HL")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        // 包装导航控制器
        let nav = BaseNavigationController(rootViewController: childController)
        self.addChildViewController(nav)
    }
    

}
