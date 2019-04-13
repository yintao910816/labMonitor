//
//  UserSettingViewController.swift
//  labMonitor
//
//  Created by huchuang on 2018/3/27.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserSettingViewController: UIViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        t.backgroundColor = kBackgroundColor
        t.dataSource = self
        t.delegate = self
        t.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        t.tableFooterView = UIView()
        self.view.addSubview(t)
        return t
    }()

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人设置"
        self.view.backgroundColor = kDefaultThemeColor

        initUI()
        
        tableV.register(UserSettingTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        tableV.reloadData()
    }
    
    func initUI(){
        let logoutBtn = UIButton.init()
        self.view.insertSubview(logoutBtn, aboveSubview: tableV)
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.backgroundColor = kDefaultThemeColor
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.bottom.equalTo(self.view).offset(-40)
            make.height.equalTo(40)
        }
        logoutBtn.addTarget(self, action: #selector(UserSettingViewController.logout), for: .touchUpInside)
    }
    
    @objc func logout(){
        let alertController = UIAlertController(title: "提醒",
                                                message: "确认退出吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action)->() in
            //
        })
        let okAction = UIAlertAction(title: "退出", style: .default, handler: {(action)->() in
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.HC_login_out(callback: { ret, msg in
                if ret == true {
                    SVProgressHUD.dismiss()
                    UserManager.shareIntance.logout()
                    UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController.init(rootViewController: LoginViewController())
                }else {
                    SVProgressHUD.showError(withStatus: msg)
                }
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true) {
            //
        }
    }
    
}

extension UserSettingViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserSettingTableViewCell
        if indexPath.row == 0{
            cell.titleL.text = "修改密码"
        }else{
            cell.titleL.text = "修改手机号"
            cell.subTitleL.text = UserManager.shareIntance.currentUser?.phonenum
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(ModifyPasswordViewController(), animated: true)
        }else{
            self.navigationController?.pushViewController(ModifyPhoneViewController(), animated: true)
        }
    }
}
