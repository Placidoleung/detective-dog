//
//  WebViewController.swift
//  ztg
//
//  Created by 帅哥梁鹏皓 on 16/12/4.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit
import WechatKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var urlencode : String!
    
    var newTitle: String!
    
    
    lazy var WebView : UIWebView = {
        
        let temp = UIWebView.init(frame:CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height*0.91))
        
        return temp
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationController()

        addSubview()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        clearViews()
    }
    
    func addSubview() {
        
        WebView.delegate = self
        self.view.addSubview(WebView)
        if let url = urlencode{
            WebView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
        
    }
    
    func setupNavigationController(){
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "侦探狗"
        
        let installed = WechatManager.sharedInstance.isInstalled()
        //用户安装有微信即显示分享
        if installed == true {
            
            let item=UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(shareButtonClicked))
            self.navigationItem.rightBarButtonItem=item
            
        }
        
        
        
    }
    
    func clearViews() {
        for v in self.view.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
    
    func shareButtonClicked(){
        
        let alertController = UIAlertController(title: "分享新闻", message: "您可以分享给微信好友，朋友圈或者微信收藏",
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let friendAction = UIAlertAction(title: "分享给微信好友", style: .Default) { (_) in
            
            WechatManager.sharedInstance.share(WXSceneSession, image: UIImage(named:"ic_app.png"), title: self.newTitle, description: "分享自侦探狗APP", url: self.urlencode)
            
        }
        let circleAction = UIAlertAction(title: "分享到朋友圈", style: .Default) { (_) in
            
            WechatManager.sharedInstance.share(WXSceneTimeline, image: UIImage(named:"ic_app.png"), title: self.newTitle, description: "分享自侦探狗APP", url: self.urlencode)
            
        }
        let collectionAction = UIAlertAction(title: "分享到微信收藏", style: .Default) { (_) in
            
            WechatManager.sharedInstance.share(WXSceneFavorite, image: UIImage(named:"ic_app.png"), title: self.newTitle, description: "分享自侦探狗APP", url: self.urlencode)
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(friendAction)
        alertController.addAction(circleAction)
        alertController.addAction(collectionAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
