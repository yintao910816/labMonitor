//
//  WebViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD
import WebKit

class WebViewController: UIViewController {
    
    
    var context : JSContext?

    
    var webView : WKWebView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent    
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kDefaultThemeColor
        
        
        let t = self.title
        var url : String!
        
        if t == "监控"{
            url = H5_ROOT_URL + "view/monitoring.html"
        }else if t == "警报"{
            url = H5_ROOT_URL + "view/alarm.html"
        }else{
            url = H5_ROOT_URL + "view/equipment.html"
        }
        
//        if t == "监控"{
//            url = "http://192.168.0.101:8088/examples/H5-test/view/monitoring.html"
//        }else if t == "警报"{
//            url = "http://192.168.0.101:8088/examples/H5-test/view/alarm.html"
//        }else{
//            url = "http://192.168.0.101:8088/examples/H5-test/view/equipment.html"
//        }
        
        
        let webConfiguration = WKWebViewConfiguration()
        
        let userContentController = WKUserContentController()
        
        let dic = UserDefaults.standard.value(forKey: kUserDic)
        
        if let dic = dic {
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted){
                
                if let s = String.init(data: data, encoding: String.Encoding.utf8){
                    // js代码片段
                    let jsStr = "sessionStorage.setItem('getUserInfo', JSON.stringify(\(s)));"
                    HCPrint(message: jsStr)
                    // 根据JS字符串初始化WKUserScript对象
                    let userScript = WKUserScript(source: jsStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                    userContentController.addUserScript(userScript)
                }
            }
        }
        
        
        //  注入js方法
        let jsStr = "wyCommon.openUserSettingView = function() {window.webkit.messageHandlers.openUserSettingView.postMessage('open');};" +
            "wyCommon.popwarn = function( id, type ) {window.webkit.messageHandlers.popwarn.postMessage(id);};" +
        "wyCommon.hideBottomTabBar = function(param) {window.webkit.messageHandlers.hideBottomTabBar.postMessage(param);};" +
        "wyCommon.getUserInfo = function() {return JSON.parse(sessionStorage.getItem('getUserInfo'));};" +
        "wyCommon.nativePrint = function(s) {window.webkit.messageHandlers.nativePrint.postMessage(s);};"
        // 根据JS字符串初始化WKUserScript对象
        let userScript = WKUserScript(source: jsStr, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        
        
        userContentController.add(self, name: KopenUserSettingView)
        userContentController.add(self, name: KhideBottomTabBar)
        userContentController.add(self, name: Kpopwarn)
        userContentController.add(self, name: KnativePrint)

        // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
        webConfiguration.userContentController = userContentController
        
        let space = AppDelegate.shareIntance.space
        
//        webView = WKWebView(frame: CGRect.init(x: 0, y: space.topSpace, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace), configuration: webConfiguration)
        
        webView = WKWebView(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), configuration: webConfiguration)
        
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        
    
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView?.load(myRequest)
        
        view.addSubview(webView!)
        
        
        let statusBarV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: space.topSpace))
        statusBarV.backgroundColor = kDefaultThemeColor
        view.addSubview(statusBarV)
        
        SVProgressHUD.show()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}


extension WebViewController: WKUIDelegate, WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        HCPrint(message: "navigationAction")
        
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        HCPrint(message: "didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        HCPrint(message: "didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HCPrint(message: "didFinish")
        
        SVProgressHUD.dismiss()
        
        if webView.canGoBack{
            self.navigationController?.tabBarController?.tabBar.isHidden = true
        }else{
            self.navigationController?.tabBarController?.tabBar.isHidden = false
        }
        
        let t = webView.title
        if let t = t {
            if t == "401"{
                UserManager.shareIntance.logout(showMsg: true)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HCPrint(message: "didFail")
        SVProgressHUD.dismiss()
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        HCPrint(message: "navigationResponse")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        HCPrint(message: "didReceiveServerRedirectForProvisionalNavigation")
    }
    
    
    
    //WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        HCPrint(message: "createWebViewWith")
        return WKWebView.init(frame: webView.frame, configuration: configuration)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        HCPrint(message: "runJavaScriptAlertPanelWithMessage")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        HCPrint(message: "runJavaScriptConfirmPanelWithMessage")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) -> Void in
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        HCPrint(message: "runJavaScriptTextInputPanelWithPrompt")
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction(title: "完成", style: .default, handler: { (_) -> Void in
            completionHandler(alert.textFields![0].text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        HCPrint(message: "webViewWebContentProcessDidTerminate")
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        HCPrint(message: "webViewDidClose")
    }
    
    
}


extension WebViewController: WKScriptMessageHandler{
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        HCPrint(message: message.name)
        HCPrint(message: message.body)
        switch message.name{
        case KopenUserSettingView:
            HCPrint(message: "KopenUserSettingView")
            self.navigationController?.pushViewController(UserSettingViewController(), animated: true)
        case KhideBottomTabBar:
            HCPrint(message: "KhideBottomTabBar")
        case Kpopwarn:
            HCPrint(message: "Kpopwarn")
            if let id = message.body as? String{
                
                let alertVC = AlertViewController()
                alertVC.onlyAction = true
                alertVC.Instrument_No = id
                alertVC.modalPresentationStyle = .custom
                
                alertVC.H5Block = {[weak self]()in
                    self?.webView?.evaluateJavaScript("wyAlaD.shielding()", completionHandler: { (result, error) in
                        //
                    })
                }
                
                self.present(alertVC, animated: false, completion: nil)
            }
        default:
            HCPrint(message: message.body)
        }
    }
}


