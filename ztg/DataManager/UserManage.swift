//
//  UserManage.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/18.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import Foundation
import LeanCloud
import RealmSwift
import SwiftMessages

typealias userBlock = (user:LCUser) -> Void
typealias signUpBlock = (code:Int) -> Void

class UserManage {
    
    var User = LCUser()
    
    var userCallBack = userBlock?()
    var signUpCallBack = signUpBlock?()
    
    func userSignUp(openId:String){
        let randomUser = LCUser()
        
        randomUser.username = LCString(openId)
        randomUser.password = LCString(openId)
        randomUser.signUp { (result) in
            switch result{
                
            case .Success:
                print("success")
                if self.signUpCallBack != nil {
                    
                    self.signUpCallBack!(code: 9999)
                    
                }
                
            case .Failure(let error):
                
                if self.signUpCallBack != nil {
                    
                    self.signUpCallBack!(code: error.code)
                    
                }
                
                
            }
        }
        
            
        }
    
    func userLogIn(openId:String){
        
        
        LCUser.logIn(username: openId, password: openId) { result in
            switch result {
            case .Success(let user):
                currentUser = user
                if self.userCallBack != nil {
                    
                    self.userCallBack!(user: user)
                    
                }
                
                // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
                // files in the main bundle first, so you can easily copy them into your project and make changes.
                let view = MessageView.viewFromNib(layout: .CardView)
                
                // Theme message elements with the warning style.
                view.configureTheme(.Success)
                
                view.configureDropShadow()
                view.button?.removeFromSuperview()

                view.configureContent(title: "成功", body: "登录成功")
                
                SwiftMessages.show(view: view)

                
                break
            case .Failure(let error):

                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Error)
                
                view.button?.removeFromSuperview()

                view.configureDropShadow()
                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                view.configureContent(title: "出错啦", body: "获取用户数据失败", iconText: iconText)
                
                // Show the message.
                SwiftMessages.show(view: view)

                
                
            }
            
        }
        
        
        
    }
    
    func followUpdate(user:LCUser,channel:String) {
        
        user.append("channels", element: LCString(channel), unique: true)
        currentUser = user
        user.save { result in
            switch result {
            case .Success:

                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Success)
                
                view.configureDropShadow()

                let iconText = ["😊"].sm_random()!
                view.configureContent(title: "成功", body: "成功订阅\(channel)", iconText: iconText)
                view.button?.removeFromSuperview()
                // Show the message.
                SwiftMessages.show(view: view)

            break // 更新成功
            case .Failure(let error):
                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Error)
                
                view.button?.removeFromSuperview()
                
                view.configureDropShadow()
                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                view.configureContent(title: "出错啦", body: "订阅\(channel)失败", iconText: iconText)
                SwiftMessages.show(view: view)
                print(error)
            }
        }
        
    }
    
    func followDelete(user:LCUser,channel:String) {
        
        user.remove("channels", element: LCString(channel))
        currentUser = user
        user.save { result in
            switch result {
            case .Success:
                print("成功删除\(channel)到\(user.username?.value)")
            break // 更新成功
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    func userCallBackBlock(block: (user:LCUser) -> Void) {
        
        
        userCallBack = block
        
    }
    
    func signUpCallBackBlock(block: (code:Int) -> Void) {
        
        
        signUpCallBack = block
        
    }
    
    
    
}
