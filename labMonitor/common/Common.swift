//
//  Common.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Photos
import SDWebImage

//用户信息
let kUserPhone = "kUserPhone"
let kPassWord = "kPassWord"
let kUserDic = "kUserDic"

let kDeviceToken = "deviceToken"

//字体
let kReguleFont = "PingFangSC-Regular"
let kBoldFont = "PingFangSC-Semibold"

let kTextSize : CGFloat = 16


let NOTE_GET = "noteGet"


typealias blankBlock = ()->()




let kAppID = "1059226236"

let KUMengKey = "5ab861de8f4a9d595f00002f"


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height


let kDefaultThemeColor = UIColor.init(red: 73/255.0, green: 137/255.0, blue: 235/255.0, alpha: 1)
let kdivisionColor = UIColor.init(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
let kTextColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
let kLightTextColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
let kBackgroundColor = UIColor.init(red: 244/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1)




let KopenUserSettingView = "openUserSettingView"
let KhideBottomTabBar = "hideBottomTabBar"
let KgetUserInfo = "getUserInfo"
let Kpopwarn = "popwarn"
let KnativePrint = "nativePrint"

func HCPrint<T>(message: T,
             logError: Bool = false,
             file: String = #file,
             method: String = #function,
             line: Int = #line){
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}

func HCShowInfo(info : String){
    SVProgressHUD.showInfo(withStatus: info)
}

func HCShowError(info : String){
    SVProgressHUD.showError(withStatus: info)
}

func FindRealClassForDicValue(dic : [String : Any]){
    for key in dic.keys{
        let value = dic[key]
        let ob = value as AnyObject
        
        let s = "var \(key) : \(ob.classForCoder) ?"
        let tempS = s.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ") ", with: "").replacingOccurrences(of: "NSString", with: "String")
        
        print(tempS)
    }
}

func createImage(color: UIColor) -> UIImage? {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? nil
}

// 随机颜色
func randomColor()-> UIColor{
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let alpha = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    
    return UIColor.init(red:red, green:green, blue:blue , alpha: alpha)
}


func checkIsPhone(_ number : String)->(Bool){
    let regex = "^1\\d{10}$"
    let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with:number)
}

//显示消息
func showAlert(title:String, message:String){
    
    let alertController = UIAlertController(title: title,
                                            message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true,
                                                                completion: nil)
}

func showAlert(title : String, message : String, callback : @escaping (()->())){
    let alertController = UIAlertController(title: title,
                                            message: message, preferredStyle: .alert)
    let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
    }
    let callAction = UIAlertAction(title: "好的", style: .default) { (action) in
        callback()
    }
    alertController.addAction(tempAction)
    alertController.addAction(callAction)
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
}


// 相册权限
func checkPhotoLibraryPermissions() -> Bool {
    
    let library : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted || library == PHAuthorizationStatus.notDetermined){
        return false
    }else {
        return true
    }
}

func authorizationForPhotoLibrary(confirmBlock : @escaping blankBlock){
    
    PHPhotoLibrary.requestAuthorization { (status) in
        if status == PHAuthorizationStatus.authorized{
            DispatchQueue.main.async {
                confirmBlock()
            }
        }else if status == PHAuthorizationStatus.denied{
            HCShowError(info: "未能获取图片！")
        }
    }
}

// 相机权限
func checkCameraPermissions() -> Bool {
    
    let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
        return false
    }else {
        return true
    }
}

func authorizationForCamera(confirmBlock : @escaping blankBlock){
    
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
        if granted == true {
            confirmBlock()
        }else{
            HCShowError(info: "未能开启相机！")
        }
    }
}


// 麦克风权限
func checkMicrophonePermissions() -> Bool {
    
    let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    
    if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
        return false
    }else {
        return true
    }
}

func authorizationForMicrophone(confirmBlock : @escaping blankBlock){
    
    AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
        if granted == true {
            confirmBlock()
        }else{
            HCShowError(info: "未能开启语音！")
        }
    }
    
}


func HC_getTopAndBottomSpace()->(CGFloat, CGFloat){
    //兼容iPhone X
    var cutTop : CGFloat!
    var cutBottom : CGFloat!
    if #available(iOS 11.0, *) {
        if SCREEN_HEIGHT == 812 {   //iphone X
            let top = UIApplication.shared.keyWindow?.safeAreaInsets.top
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
            cutTop = top!
            cutBottom = bottom!
        }else{
            cutTop = 20
            cutBottom = 0
        }
    } else {
        cutTop = 20
        cutBottom = 0
    }
    return (cutTop, cutBottom)
}


extension UIImageView {
    
    func HC_setImageFromURL(urlS : String, placeHolder : String){
        if urlS.contains("http"){
            self.sd_setImage(with: URL.init(string: urlS), placeholderImage: UIImage.init(named: placeHolder), options: .cacheMemoryOnly, completed: nil)
        }else{
            self.sd_setImage(with: URL.init(string: IMAGE_URL + urlS), placeholderImage: UIImage.init(named: placeHolder), options: .cacheMemoryOnly, completed: nil)
        }
    }
    
}


extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}

extension Date {
    
    static func createTimeWithString(_ number : String) -> String {
        // 1.创建时间格式化对象
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en")
        //        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 2.获取时间
        //        guard let createDate = fmt.date(from: timeString) else {
        //            return ""
        //        }
        
        guard let milliseconds = Int(number) else{
            return ""
        }
        let timeStamp = TimeInterval.init(milliseconds)/1000.0
        let createDate = Date.init(timeIntervalSince1970: timeStamp)
        
        
        // 3.获取当前时间
        let nowDate = Date()
        
        // 4.获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 5.判断时间显示的格式
        // 5.1.1分钟之内
        if interval < 60 {
            return "刚刚"
        }
        
        // 5.2.一个小时内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 5.3.一天之内
        if interval < 60 * 60 * 24 {
            return "\(interval / 60 / 60)小时前"
        }
        
        // 6.其他时间的显示
        // 6.1.创建日期对象
        let calendar = Calendar.current
        
        // 6.2.昨天的显示
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "HH:mm"
            let timeString = fmt.string(from: createDate)
            return "昨天 \(timeString)"
        }
        
        // 6.3.一年之内
        let cpns = (calendar as NSCalendar).components(NSCalendar.Unit.year, from: createDate, to: nowDate, options: [])
        if cpns.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeString = fmt.string(from: createDate)
            return timeString
        }
        
        // 6.4.一年以上
        fmt.dateFormat = "yyyy-MM-dd"
        let timeString = fmt.string(from: createDate)
        
        return timeString
    }
    
    
    static func isWithin24hours(_ number : NSNumber) -> Bool{
        
        let milliseconds = number.intValue
        let timeStamp = TimeInterval.init(milliseconds)/1000.0
        let createDate = Date.init(timeIntervalSince1970: timeStamp)
        // 3.获取当前时间
        let nowDate = Date()
        
        // 4.获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 5.3天之内 60 * 60 * 24 * 10
        if interval < 86400 {
            return true
        }else{
            return false
        }
    }
    
    func converteYYYYMMddHHmmss()->String{
        let format = DateFormatter.init()
        format.dateFormat = "YYYYMMddHHmmss"
        return format.string(from: self)
    }
    
    func converteYYYYMMdd()->String{
        let format = DateFormatter.init()
        format.dateFormat = "YYYY-MM-dd"
        return format.string(from: self)
    }
}




