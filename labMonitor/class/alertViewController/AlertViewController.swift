//
//  AlertViewController.swift
//  labMonitor
//
//  Created by huchuang on 2018/3/29.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class AlertViewController: UIViewController {
    
    var H5Block : (()->())?
    
    let contV = UIView()
    lazy var titleL : UILabel = UILabel()
    lazy var contentL : UILabel = UILabel()
    
    lazy var timeL : UILabel = UILabel()
    
    lazy var halfHourBtn : UIButton = createButton(title: "30分钟后再提醒", tag: 1, sel: #selector(AlertViewController.click))
    
    var Instrument_No : String?
    
    
    var onlyAction : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.8)
        
        let w : CGFloat = 280
    
        self.view.addSubview(contV)
        contV.snp.updateConstraints { (make) in
            make.width.equalTo(w)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-44)
        }
        contV.backgroundColor = UIColor.white
        contV.layer.cornerRadius = 5
        contV.clipsToBounds = true
        
        contV.addSubview(titleL)
        titleL.frame = CGRect.init(x: 0, y: 0, width: w, height: 50)
        titleL.textAlignment = NSTextAlignment.center
        titleL.backgroundColor = kDefaultThemeColor
        titleL.textColor = UIColor.white
        titleL.font = UIFont.init(name: kBoldFont, size: kTextSize + 2)
        titleL.text = "消息处理"
        
        let closeBtn = UIButton.init()
        closeBtn.tag = 9
        closeBtn.setImage(UIImage.init(named: "关闭按钮"), for: .normal)
        contV.addSubview(closeBtn)
        closeBtn.frame = CGRect.init(x: w - 40, y: 15, width: 20, height: 20)
        closeBtn.addTarget(self, action: #selector(AlertViewController.click), for: .touchUpInside)
        
        if onlyAction == false{
            
            contV.addSubview(contentL)
            contentL.snp.updateConstraints { (make) in
                make.top.equalTo(titleL.snp.bottom).offset(10)
                make.left.equalTo(contV).offset(15)
                make.right.equalTo(contV).offset(-15)
            }
            contentL.textAlignment = NSTextAlignment.left
            contentL.font = UIFont.init(name: kReguleFont, size: kTextSize)
            contentL.textColor = kLightTextColor
            contentL.lineBreakMode = NSLineBreakMode.byWordWrapping
            contentL.numberOfLines = 5
            
            contV.addSubview(timeL)
            timeL.snp.updateConstraints { (make) in
                make.top.equalTo(contentL.snp.bottom).offset(5)
                make.left.equalTo(contentL)
                make.height.equalTo(20)
            }
            timeL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
            timeL.textColor = kLightTextColor
            
            let rightIMV = UIButton()
            rightIMV.tag = 10
            rightIMV.setImage(UIImage.init(named: "right"), for: .normal)
            contV.addSubview(rightIMV)
            rightIMV.snp.updateConstraints { (make) in
                make.centerY.equalTo(timeL)
                make.width.equalTo(10)
                make.height.equalTo(15)
                make.right.equalTo(contentL)
            }
            rightIMV.addTarget(self, action: #selector(AlertViewController.click), for: .touchUpInside)
            
            contV.addSubview(halfHourBtn)
            halfHourBtn.snp.updateConstraints { (make) in
                make.top.equalTo(timeL.snp.bottom).offset(10)
                make.left.right.equalTo(contV)
                make.height.equalTo(44)
            }
        }else{
            contV.addSubview(halfHourBtn)
            halfHourBtn.snp.updateConstraints { (make) in
                make.top.equalTo(titleL.snp.bottom)
                make.left.right.equalTo(contV)
                make.height.equalTo(44)
            }
        }
        
        let oneHourBtn = createButton(title: "1小时后再提醒", tag: 2, sel: #selector(AlertViewController.click))
        contV.addSubview(oneHourBtn)
        oneHourBtn.snp.updateConstraints { (make) in
            make.top.equalTo(halfHourBtn.snp.bottom)
            make.left.right.equalTo(contV)
            make.height.equalTo(44)
        }

        let oneDayBtn = createButton(title: "24小时后再提醒", tag: 3, sel: #selector(AlertViewController.click))
        contV.addSubview(oneDayBtn)
        oneDayBtn.snp.updateConstraints { (make) in
            make.top.equalTo(oneHourBtn.snp.bottom)
            make.left.right.equalTo(contV)
            make.height.equalTo(44)
        }

        let forbidBtn = createButton(title: "屏蔽该类型消息", tag: 4, sel: #selector(AlertViewController.click))
        contV.addSubview(forbidBtn)
        forbidBtn.snp.updateConstraints { (make) in
            make.top.equalTo(oneDayBtn.snp.bottom)
            make.left.right.equalTo(contV)
            make.height.equalTo(44)
            make.bottom.equalTo(contV)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if let id = Instrument_No{
//            HttpRequestManager.shareIntance.HC_readedMessage(Instrument_No: id, callback: { (bool, msg) in
//                //
//            })
//        }
//    }
    
    @objc func click(btn : UIButton){
        HCPrint(message: btn.tag)
        
        if btn.tag == 9{
            dismissVC()
        }else if btn.tag == 10{
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                if rootVC.isKind(of: UITabBarController.classForCoder()){
                    let tabVC = rootVC as! UITabBarController
                    tabVC.selectedIndex = 1
                }
            }
            dismissVC()
        }else{
            var Disposecode = ""
            switch btn.tag{
            case 1:
                Disposecode = "1"
            case 2:
                Disposecode = "2"
            case 3:
                Disposecode = "48"
            case 4:
                Disposecode = "4"
            default:
                Disposecode = "1"
            }
            
            if let id = Instrument_No{
                SVProgressHUD.show()
                HttpRequestManager.shareIntance.HC_dealWithMessage(Instrument_No: id, Disposecode: Disposecode, callback: { [weak self](bool, msg) in
                    if bool{
                        HCShowInfo(info: msg)
                        if let block = self?.H5Block{
                            block()
                        }
                        self?.dismissVC()
                    }else{
                        HCShowError(info: msg)
                    }
                })
            }else{
                dismissVC()
            }
            
        }
        
    }
    
    func dismissVC(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { (bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func createButton(title : String, tag : NSInteger, sel : Selector)->UIButton{
        let b = UIButton.init()
        b.tag = tag
        b.setTitle(title, for: .normal)
        b.setTitleColor(kDefaultThemeColor, for: .normal)
        b.addTarget(self, action: sel, for: .touchUpInside)
        b.layer.borderColor = kdivisionColor.cgColor
        b.layer.borderWidth = 0.5
        return b
    }

}
