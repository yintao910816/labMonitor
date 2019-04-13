//
//  network.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation


let HTTP_RESULT_SERVER_ERROR = "服务器出错！"
let HTTP_RESULT_NETWORK_ERROR = "网络出错，请检查网络连接！"


let HC_HOST_URL = "http://39.104.178.216:8087/api-mon/"

//let HC_HOST_URL = "http://192.168.1.105:8094/"

let IMAGE_URL = "https://www.ivfcn.com"


//用户登录 
let HC_LOGIN = HC_HOST_URL + "api/userInfo/userLogin"

// 登出
let HC_LOGIN_OUT = HC_HOST_URL + "api/userInfo/loginOut"

//验证码 get
let HC_VALIDATECODE = HC_HOST_URL + "api/userInfo/getCode"

//修改密码
let HC_MODIFY_PASSWORD = HC_HOST_URL + "api/userInfo/updatePwd"

// 检查版本更新
let HC_CHECK_VERSION = HC_HOST_URL + "apk/checkIos"

//修改手机号
let HC_MODIFY_PHONE = HC_HOST_URL + "api/userInfo/updatePhone"

////更新deviceToken
//let HC_DEVICE_TOKEN = HC_HOST_URL + "api/userinfo/openPushMessage"

//报警消息已读
let HC_READED = HC_HOST_URL + "api/alarmsetting/readalarm"

//报警消息处理
let HC_DEAL_MESSAGE = HC_HOST_URL + "api/insParamSet/pushSet"

// 更新devicetoken
let HC_UPDATE_DEVICETOKEN = HC_HOST_URL + "api/insParamSet/updateDevicetoken"

let H5_ROOT_URL = "http://39.104.178.216:8098/H5/"

//let H5_ROOT_URL = "http://192.168.1.55:8080/H5/"
