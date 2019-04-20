//
//  LoginViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class LoginViewController: UIViewController {
    
    let imgH = SCREEN_WIDTH / 750 * 550
    
    let aileyunImgV = UIImageView.init(image: UIImage.init(named: "guanggao"))
    
    let containerV = UIView.init()
    
    let cellphoneTF = UITextField()
    let passwordTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kBackgroundColor
        
        observeKeyboard()
        
        initLoginV()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func initLoginV(){
        
        self.view.addSubview(aileyunImgV)
        aileyunImgV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: imgH)
        aileyunImgV.contentMode = UIViewContentMode.scaleToFill
        
        containerV.frame = CGRect.init(x: 0, y: imgH, width: SCREEN_WIDTH, height: 300)
        self.view.addSubview(containerV)
        
        
        let contV1 = UIView.init()
        contV1.backgroundColor = UIColor.white
        containerV.addSubview(contV1)
        contV1.snp.updateConstraints { (make) in
            make.top.equalTo(containerV).offset(20)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(50)
        }
        
        
        let headL = UIImageView.init(image: UIImage.init(named: "账户"))
        contV1.addSubview(headL)
        headL.snp.updateConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(contV1).offset(15)
            make.centerY.equalTo(contV1)
        }
        
        contV1.addSubview(cellphoneTF)
        cellphoneTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(headL)
            make.left.equalTo(headL.snp.right).offset(20)
            make.right.equalTo(contV1).offset(-10)
        }
        cellphoneTF.placeholder = "请输入您的账户名"
        cellphoneTF.font = UIFont.init(name: kReguleFont, size: 16)
        cellphoneTF.textColor = kTextColor
        cellphoneTF.clearButtonMode = .whileEditing
        cellphoneTF.text = UserDefaults.standard.value(forKey: kUserPhone) as? String
        cellphoneTF.keyboardType = .namePhonePad
        
        
        let contV2 = UIView.init()
        contV2.backgroundColor = UIColor.white
        containerV.addSubview(contV2)
        contV2.snp.updateConstraints { (make) in
            make.top.equalTo(contV1.snp.bottom).offset(10)
            make.left.right.height.equalTo(contV1)
        }
        
        let passwordL = UIImageView.init(image: UIImage.init(named: "密码"))
        contV2.addSubview(passwordL)
        passwordL.snp.updateConstraints { (make) in
            make.left.equalTo(contV2).offset(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(contV2)
        }
        
        contV2.addSubview(passwordTF)
        passwordTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(passwordL)
            make.left.equalTo(passwordL.snp.right).offset(20)
            make.right.equalTo(contV2).offset(-10)
        }
        passwordTF.font = UIFont.init(name: kReguleFont, size: 16)
        passwordTF.textColor = kTextColor
        passwordTF.placeholder = "请输入您的密码"
        passwordTF.isSecureTextEntry = true
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.delegate = self
        
        
        let loginBtn = UIButton()
        containerV.addSubview(loginBtn)
        loginBtn.snp.updateConstraints { (make) in
            make.top.equalTo(contV2.snp.bottom).offset(30)
            make.left.right.equalTo(contV2)
            make.height.equalTo(40)
        }
        loginBtn.setTitle("登 录", for: UIControlState.normal)
        loginBtn.layer.cornerRadius = 5
        loginBtn.backgroundColor = kDefaultThemeColor
        
        loginBtn.addTarget(self, action: #selector(LoginViewController.login), for: UIControlEvents.touchUpInside)
        
        #if DEBUG
        cellphoneTF.text = "xjjyios"
        passwordTF.text  = "xjjyios"
        #endif

    }
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        let rect = CGRect.init(x: 0, y: imgH, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 1
        }
    }
    
    @objc func login(){
        
        guard cellphoneTF.text != "" && cellphoneTF.text != nil else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard passwordTF.text != "" && passwordTF.text != nil else {
            HCShowError(info: "请输入密码！")
            return
        }

        self.view.endEditing(true)
        let rect = CGRect.init(x: 0, y: imgH, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 1
        }

        SVProgressHUD.show()

        let t = UserDefaults.standard.value(forKey: kDeviceToken) as? String ?? ""

        HttpRequestManager.shareIntance.HC_login(account: cellphoneTF.text!, password: passwordTF.text!, devicetoken : t) { [weak self](bool, msg) in
            if bool{
                SVProgressHUD.dismiss()
                UserDefaults.standard.set(self?.cellphoneTF.text, forKey: kUserPhone)
                UserDefaults.standard.set(self?.passwordTF.text, forKey: kPassWord)
                UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
            }else{
                HCShowError(info: msg)
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}


extension LoginViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {   //增加字符的情况
            let t = textField.text ?? ""
            textField.text = t + string
            return false
        }
        return true
    }
    
}


extension LoginViewController {
    func observeKeyboard() -> () {
        //注册键盘出现的通知
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    @objc func keyboardShow() -> () {
        let rect = CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 0.5
        }
    }
    
}
