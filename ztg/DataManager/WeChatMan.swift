//
//  WeChatMan.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/27.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import Foundation
import WechatKit

typealias wechatBlock = (openId:String) -> Void

class WechatMan {
    
    
    
    var wechatCallback = wechatBlock?()
    
    func WechatLogIn(){
        
        
        WechatManager.sharedInstance.checkAuth { result in
            switch result {
            case .Failure(let errCode)://登录失败
                print(errCode)
            case .Success(let value)://登录成功 value为([String: String]) 微信返回的openid access_token 以及 refresh_token
                if self.wechatCallback != nil {
                    
                    let openid = value["openid"] as! String
                    self.wechatCallback!(openId: openid)
                    
                }
            }
        }
        
    }
    
    func wechatCallBackBlock(block: (openid:String) -> Void) {
        
        wechatCallback = block
        
    }
    
}
