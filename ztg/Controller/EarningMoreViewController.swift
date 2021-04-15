//
//  EarningMoreViewController.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/12/12.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit

class EarningMoreViewController: UIViewController, earningUpSegmentDelegate, tigerSegmentDelegate {
    
    lazy var segment : EarningUpSegment = {
        
        let temp = EarningUpSegment.init(frame: CGRectMake(0, 0.02*self.view.bounds.height, self.view.bounds.width, self.view.bounds.height*0.15))
        temp.delegate = self

        return temp
        
    }()
    
    lazy var tigerSegment : TigerSegment = {
        
        let temp = TigerSegment.init(frame: CGRectMake(0, 0.19*self.view.bounds.height, self.view.bounds.width, self.view.bounds.height*0.15))
        temp.delegate = self
        
        return temp
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        addNavigatonBar()
        addSubview()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //添加导航栏
    func addNavigatonBar(){
        
        self.navigationController?.navigationBar.translucent  = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
        self.title = "侦探狗"
        self.navigationController?.title = "收益+"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    func addSubview(){
        
        self.view.addSubview(segment)
        self.view.addSubview(tigerSegment)
        
    }
    
    func earnButtonDidClicked() {
        
        self.hidesBottomBarWhenPushed = true
        
        let webView = WebViewController()
        
        webView.newTitle = "宜人贷"
        
        webView.urlencode = "http://5g.yirendai.com/gt/zc2/?siteId=xcsqd1"
        
        self.navigationController?.pushViewController(webView, animated: true)
        
        self.hidesBottomBarWhenPushed = false
        
    }
    
    func tigerButtonDidClicked(){
        
        self.hidesBottomBarWhenPushed = true
        
        let webView = WebViewController()
        
        webView.newTitle = "老虎证券"
        
        webView.urlencode = "https://www.tigerbrokers.com/market/201602?invite=TIGER296&amp;noPromotion"
        
        self.navigationController?.pushViewController(webView, animated: true)
        
        self.hidesBottomBarWhenPushed = false
        
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
