//
//  UIKit+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/8.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

extension NSObject {
    
    public var visibleViewController: UIViewController? {
        get {
            guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else{
                return nil
            }
            return getVisibleViewController(from: rootVC)
        }
    }
    
    private func getVisibleViewController(from: UIViewController?) ->UIViewController? {
        if let nav = from as? UINavigationController {
//            return getVisibleViewController(from:nav.visibleViewController)
            return getVisibleViewController(from:nav.viewControllers.last)
        }else if let tabBar = from as? UITabBarController {
            return getVisibleViewController(from: tabBar.selectedViewController)
        }else {
            guard let presentedVC = from?.presentedViewController else {
                return from
            }
            return getVisibleViewController(from: presentedVC)
        }
        
    }
}

extension NSObject {
    
    public static func alert(title         : String? = nil,
                             message       : String,
                             cancleTitle   : String? = nil,
                             okTitle       : String? = "确定",
                             presentCtrl   : UIViewController? = NSObject().visibleViewController,
                             callBackCancle: (() ->Void)? = nil,
                             callBackOK    : (() ->Void)? = nil) {
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: okTitle, style: .default) { _ in
            guard let callBack = callBackOK else{
                return
            }
            callBack()
        }
        alertVC.addAction(okAction)
        
        if cancleTitle?.isEmpty == false {
            let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel) { _ in
                guard let callBack = callBackCancle else{
                    return
                }
                callBack()
            }
            alertVC.addAction(cancelAction)
        }
        
        presentCtrl?.present(alertVC, animated: true)
    }

}
