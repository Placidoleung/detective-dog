//
//  LogInViewController.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/12/6.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit
import SwiftMessages

typealias ValueClosure = (String)->Void

class LogInViewController: UIViewController{
    
    let wechat = WechatMan()
    let userMan = UserManage()
    var backValueClosure : ValueClosure?
    
    
    lazy var ztgImage : UIImageView = {
        
        let temp = UIImageView(frame:CGRectMake(0.5*self.view.bounds.width-0.1371*self.view.bounds.height, 0.15*self.view.bounds.height, 0.2743*self.view.bounds.height, 0.2743*self.view.bounds.height))
        print(self.view.bounds.width)
        print(self.view.bounds.height)
        temp.image = UIImage(named:"ic_logo.png")
        
        return temp
        
    }()
    
    lazy var logInButton : UIButton = {
        
        let temp = UIButton(frame:CGRectMake(0.1*self.view.bounds.width, 0.55*self.view.bounds.height, 0.8*self.view.bounds.width, 0.0674*self.view.bounds.height))
        temp.layer.cornerRadius = 5
        temp.layer.borderColor = UIColor.whiteColor().CGColor
        temp.layer.borderWidth = 1
        temp.setTitle("通过微信登录", forState: UIControlState.Normal)
        return temp
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
        logInButton.addTarget(self, action: #selector(LogInViewController.logInButtonClick), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(ztgImage)
        self.view.addSubview(logInButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
        // Dispose of any resources that can be recreated.
    }
    
    func logInButtonClick(){
        wechat.WechatLogIn()
        
        
        wechat.wechatCallBackBlock { (openid) in
            

            self.userMan.userSignUp(openid)
            self.userMan.signUpCallBackBlock({ (code) in
                
                if code == 9999{
                    
                    //移除微信登录按钮
                    for button in self.view.subviews {
                        
                        if button.layer.borderWidth == 1{
                            
                            button.removeFromSuperview()
                            
                        }
                        
                    }

                    
                    self.userMan.userLogIn(openid)
                    let array = NSArray(objects: openid)
                    let filePath:String = NSHomeDirectory() + "/Documents/openid.plist"
                    array.writeToFile(filePath, atomically: true)
                    
                }
                else if code == 202{
                    
                    //移除微信登录按钮
                    for button in self.view.subviews {
                        
                        if button.layer.borderWidth == 1{
                            
                            button.removeFromSuperview()
                            
                        }
                        
                    }

                    
                    self.userMan.userLogIn(openid)
                    let array = NSArray(objects: openid)
                    let filePath:String = NSHomeDirectory() + "/Documents/openid.plist"
                    array.writeToFile(filePath, atomically: true)
                    
                    
                }
                
                else{
                    
                    let view = MessageView.viewFromNib(layout: .CardView)
                    
                    view.configureTheme(.Error)
                    
                    view.button?.removeFromSuperview()
                    
                    view.configureDropShadow()
                    view.configureContent(title: "登录失败", body: "登录失败了，请后台退出应用尝试重新登录")
                    SwiftMessages.show(view: view)
                    
                }
                
                
            })
            
            self.userMan.userCallBackBlock({ (user) in
                if self.backValueClosure != nil {
                    self.backValueClosure!(openid)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
