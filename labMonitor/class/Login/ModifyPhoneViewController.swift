//
//  ModifyPhoneViewController.swift
//  labMonitor
//
//  Created by huchuang on 2018/3/27.
//  Copyright © 2018年 huchuang. All rights reserved.
//


import UIKit
import SVProgressHUD

class ModifyPhoneViewController: UIViewController {
    
    let cellphoneTF = UITextField()
    let verifyBtn = UIButton()
    let verifyTF = UITextField()
    
    let seeBtn = UIButton()
    let passwordTF = UITextField()
    
    let registerBtn = UIButton()
    
    
    var count = 0
    let KMaxSeconds = 180
    
    var timer : Timer?
    
    var takeCode : Bool = false
        
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kDefaultThemeColor
        
        self.navigationItem.title = "修改手机号"
        
        initRegisterV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    func initRegisterV(){
        let space = AppDelegate.shareIntance.space
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        containerV.backgroundColor = kBackgroundColor
        self.view.addSubview(containerV)
        
        let contV = UIView.init(frame: CGRect.init(x: 0, y: 20, width: SCREEN_WIDTH, height: 150))
        contV.backgroundColor = UIColor.white
        containerV.addSubview(contV)
        
        let headL = UILabel()
        contV.addSubview(headL)
        headL.snp.updateConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.left.equalTo(contV).offset(20)
            make.top.equalTo(contV)
        }
        headL.text = "手机号"
        headL.font = UIFont.init(name: kReguleFont, size: 14)
        headL.textColor = kTextColor
        
        contV.addSubview(cellphoneTF)
        cellphoneTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(headL)
            make.left.equalTo(headL.snp.right)
            make.right.equalTo(contV).offset(-20)
            make.height.equalTo(20)
        }
        cellphoneTF.placeholder = "请输入您的新手机号"
        cellphoneTF.font = UIFont.init(name: kReguleFont, size: 14)
        cellphoneTF.textColor = kTextColor
        cellphoneTF.textAlignment = NSTextAlignment.right
        cellphoneTF.keyboardType = UIKeyboardType.numberPad
        cellphoneTF.delegate = self
        
        let divisionV = UIView()
        contV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(headL.snp.bottom)
            make.left.right.equalTo(contV)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        //验证码
        let verifyL = UILabel()
        contV.addSubview(verifyL)
        verifyL.snp.updateConstraints { (make) in
            make.left.equalTo(contV).offset(20)
            make.top.equalTo(divisionV.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        verifyL.text = "验证码"
        verifyL.font = UIFont.init(name: kReguleFont, size: 14)
        verifyL.textColor = kTextColor
        
        
        contV.addSubview(verifyBtn)
        verifyBtn.snp.updateConstraints { (make) in
            make.right.equalTo(contV).offset(-20)
            make.centerY.equalTo(verifyL)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        verifyBtn.setTitle("获取验证码", for: UIControlState.normal)
        verifyBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        verifyBtn.backgroundColor = kDefaultThemeColor
        verifyBtn.layer.cornerRadius = 5
        
        verifyBtn.addTarget(self, action: #selector(ModifyPhoneViewController.startCount), for: UIControlEvents.touchUpInside)
        
        
        contV.addSubview(verifyTF)
        verifyTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(verifyL)
            make.left.equalTo(verifyL.snp.right)
            make.right.equalTo(verifyBtn.snp.left).offset(-8)
        }
        verifyTF.placeholder = "请输入验证码"
        verifyTF.font = UIFont.init(name: kReguleFont, size: 14)
        verifyTF.textColor = kTextColor
        verifyTF.keyboardType = UIKeyboardType.numberPad
        verifyTF.textAlignment = NSTextAlignment.right
        verifyTF.delegate = self
        
        
        let diviV1 = UIView()
        contV.addSubview(diviV1)
        diviV1.snp.updateConstraints { (make) in
            make.top.equalTo(verifyL.snp.bottom)
            make.left.right.equalTo(contV)
            make.height.equalTo(1)
        }
        diviV1.backgroundColor = kdivisionColor
        
        
        let passwordL = UILabel()
        contV.addSubview(passwordL)
        passwordL.snp.updateConstraints { (make) in
            make.left.equalTo(contV).offset(20)
            make.top.equalTo(diviV1.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        passwordL.text = "密码"
        passwordL.font = UIFont.init(name: kReguleFont, size: 14)
        passwordL.textColor = kTextColor


        contV.addSubview(seeBtn)
        seeBtn.snp.updateConstraints { (make) in
            make.right.equalTo(contV).offset(-20)
            make.centerY.equalTo(passwordL)
            make.width.height.equalTo(30)
        }
        seeBtn.setImage(UIImage.init(named: "显示"), for: UIControlState.normal)
        seeBtn.addTarget(self, action: #selector(ModifyPhoneViewController.passwordStyle), for: UIControlEvents.touchUpInside)


        contV.addSubview(passwordTF)
        passwordTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(passwordL)
            make.left.equalTo(passwordL.snp.right)
            make.right.equalTo(seeBtn.snp.left).offset(-5)
        }
        passwordTF.placeholder = "请输入账户密码"
        passwordTF.font = UIFont.init(name: kReguleFont, size: 14)
        passwordTF.textColor = kTextColor
        passwordTF.textAlignment = NSTextAlignment.right
        
        
        
        containerV.addSubview(registerBtn)
        registerBtn.layer.cornerRadius = 5
        registerBtn.backgroundColor = kDefaultThemeColor
        registerBtn.snp.updateConstraints { (make) in
            make.top.equalTo(contV.snp.bottom).offset(20)
            make.left.equalTo(containerV).offset(20)
            make.right.equalTo(containerV).offset(-20)
            make.height.equalTo(40)
        }
        registerBtn.setTitle("确认提交", for: UIControlState.normal)
        registerBtn.addTarget(self, action: #selector(ModifyPhoneViewController.register), for: UIControlEvents.touchUpInside)
        
        
    }
    
    
    
    @objc func startCount(){
        guard checkIsPhone(cellphoneTF.text!) else{
            HCShowError(info: "请输入正确的手机号码！")
            return
        }
        
        verifyBtn.isEnabled = false
        
        SVProgressHUD.show(withStatus: "获取中...")
        HttpRequestManager.shareIntance.HC_validateCode(userphone: cellphoneTF.text!) { [weak self](bool, msg) in
            SVProgressHUD.dismiss()
            if bool {
                HCShowInfo(info: "获取验证码成功！")
                self?.takeCode = true
                
                self?.count = 0
                self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(ModifyPhoneViewController.showSecond), userInfo: nil, repeats: true)
            }else{
                HCShowError(info: msg)
                self?.verifyBtn.isEnabled = true
            }
        }
        
        
    }
    
    @objc func showSecond(){
        count = count + 1
        if count == KMaxSeconds {
            resetCodeBtn()
            timer?.invalidate()
        }else{
            let showString = String.init(format: "%ds重新获取", KMaxSeconds - count)
            verifyBtn.setTitle(showString, for: UIControlState.normal)
            verifyBtn.backgroundColor = kLightTextColor
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func resetCodeBtn(){
        verifyBtn.isEnabled = true
        verifyBtn.setTitle("获取验证码", for: UIControlState.normal)
        verifyBtn.backgroundColor = kDefaultThemeColor
    }
    
    @objc func passwordStyle(){
        passwordTF.isSecureTextEntry = passwordTF.isSecureTextEntry ? false : true
        if passwordTF.isSecureTextEntry {
            HCPrint(message: "隐藏")
            seeBtn.setImage(UIImage.init(named: "隐藏"), for: UIControlState.normal)
        }else{
            HCPrint(message: "显示")
            seeBtn.setImage(UIImage.init(named: "显示"), for: UIControlState.normal)
        }
    }
    
    @objc func register(){
        guard cellphoneTF.text != "" else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard takeCode == true else{
            HCShowError(info: "请获取验证码")
            return
        }
        guard verifyTF.text != "" else {
            HCShowError(info: "请输入验证码")
            return
        }
        guard passwordTF.text != "" else {
            HCShowError(info: "请输入密码！")
            return
        }
        
        if let pwd = UserDefaults.standard.value(forKey: kPassWord) as? String{
            guard passwordTF.text == pwd else{
                HCShowError(info: "密码不正确")
                return
            }
        }
        
        SVProgressHUD.show()
        let id = UserManager.shareIntance.currentUser?.userid ?? ""
        HttpRequestManager.shareIntance.HC_modifyPhone(newphonenum: cellphoneTF.text!, UserId: id, messagecode: verifyTF.text!) { [weak self](bool, msg) in
            if bool{
                HCShowInfo(info: "修改成功")
                UserManager.shareIntance.setUserPhone(phone: (self?.cellphoneTF.text)!)
                self?.navigationController?.popViewController(animated: true)
            }else{
                HCShowError(info: msg)
            }
        }
        
        
    }
    
    
    
}

extension ModifyPhoneViewController : UITextFieldDelegate {
    //限制输入字符数量
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tempText = textField.text as NSString?
        let tempString = string as NSString
        let newLength = (tempText?.length)! + tempString.length - range.length
        
        if cellphoneTF == textField {
            return newLength <= 11
        }else if verifyTF == textField{
            return newLength <= 6
        }else{
            return true
        }
    }
}


