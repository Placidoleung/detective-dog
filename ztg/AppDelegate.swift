//
//  AppDelegate.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/10/29.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit
import LeanCloud
import RealmSwift
import WechatKit

let realm = try! Realm()
var currentUser : LCUser?
var nowIndex = 0
var hasNewNews : [String] = []
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userMan = UserManage()
    let download = DownloadData()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // applicationId 即 App Id，applicationKey 是 App Key
        LeanCloud.initialize(applicationID: "Kmgx7HiBz4SPFhIuMFNspJ7u-gzGzoHsz", applicationKey: "gHJEXMeKWBgCzKd3v2rtxMvx")
        
        WechatManager.appid = "wx91c43dcf9e2d7e92"
        WechatManager.appSecret = "730f5daac76575e198cd42c1232d186e"
        
        Bugly.startWithAppId("8c85f2f99e")
        
        download.getRecommendData()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return self.application(application, openURL: url, sourceApplication: nil, annotation: [])
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WechatManager.sharedInstance.handleOpenURL(url)
        // 如需要使用其他第三方可以 使用 || 连接 其他第三方库的handleOpenURL
        // return WechatManager.sharedInstance.handleOpenURL(url) || TencentOAuth.HandleOpenURL(url) || WeiboSDK.handleOpenURL(url, delegate: SinaWeiboManager.sharedInstance) ......
    }


}

