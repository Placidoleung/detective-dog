//
//  ViewController.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/10/29.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit
import LeanCloud
import RealmSwift
import WechatKit
import SwiftMessages



class ViewController: UIViewController, subscribeSegementDelegate, recommendSegmentDelegate, updateSubscribeSegementDelegate,UITableViewDelegate, UITableViewDataSource {
    
    let CellNews  = "NewsTableViewCell"
    
    var titleArray : [String] = []
    var timeArray : [NSDate] = []
    var urlArray : [String] = []
    
    var tableViewProtocol : TableviewProtocol?
    
    let download = DownloadData()
    let wechat = WechatMan()
    let userMan = UserManage()
    
    
    lazy var tableView : UITableView = {
        
        let temp = UITableView.init(frame:CGRectMake(0, 0.437*self.view.bounds.height, self.view.bounds.width, 0.403*self.view.bounds.height))//0.403*self.view.bounds.height
        return temp
        
    }()
    
    lazy var greyView : UIView = {
        
        let temp = UIView.init(frame:CGRectMake(0, 0.27*self.view.bounds.height, self.view.bounds.width, 0.03*self.view.bounds.height))
        temp.backgroundColor = UIColor.init(colorLiteralRed: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        return temp
        
        
    }()
    
    lazy var segment : SubscribeSegment = {
        
        let temp = SubscribeSegment.init(frame: CGRectMake(0, self.view.bounds.height*0.317, self.view.bounds.width, self.view.bounds.height*0.0899))
        temp.subscribeArray = ["推荐"]
        temp.delegate = self
        
        
        return temp
        
    }()
    
    lazy var updateSegment : UpdateSubscribeSegment = {
        let temp = UpdateSubscribeSegment.init(frame: CGRectMake(0, 15, self.view.bounds.width, self.view.bounds.height*0.06))
        temp.delegate = self
        return temp
    }()
    
    lazy var recommendSegment : RecommendSegment = {
        

        let temp = RecommendSegment.init(frame: CGRectMake(0, self.view.bounds.height*0.097, self.view.bounds.width, 0.15*self.view.bounds.height))
        temp.recommendArray = []
        //获取推荐列表
        let query = LCQuery(className: "RecommendData")
        query.whereKey("data", .Selected)
        query.find { result in
            switch result {
            case .Success(let recommends):
                for recommend in recommends{
                    
                    let recommendChannel = (recommend.get("data") as! LCString).value
                    temp.recommendArray?.append(recommendChannel)
                }
            case .Failure(let error):
                print(error)
                
            }
        }
        
        
        
        
        temp.delegate = self
        
        return temp
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let userMan = UserManage()
        
        var openId:NSArray?
        
        let tanNews = realm.objects(NewsData).filter("type = 7").sorted("createdAt", ascending: false)
        
        
        for new in tanNews{
            if titleArray.count <= 10{
                
                self.titleArray.append(new.title)
                self.timeArray.append(new.createdAt)
                self.urlArray.append(new.url)
                
            }
            
            
        }
        
        
        let wechatInstalled = false//WechatManager.sharedInstance.isInstalled()
        let logIn = LogInViewController()
        if wechatInstalled == true{
            
            openId = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/openid.plist")
            if openId == nil{
                
                
                self.presentViewController(logIn, animated: true, completion: {

                    self.tableView.reloadData()
                    
                })
            }
            else{
                
                userMan.userLogIn(openId![0] as! String)
                
            }
            
        }
        
        download.redPointBackValueClosure = {(bacString:String)-> Void  in
            
            self.segment.subscribeArray?.append("refreshUI")
            self.segment.subscribeArray?.removeLast()
            
            
        }
        
        logIn.backValueClosure = {(bacString:String)-> Void  in
            
            var channels = currentUser!.get("channels")?.JSONString
            if channels != nil{
                channels = channels!.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                channels = channels!.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                channels = channels!.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let splitedArray = channels!.componentsSeparatedByString(",")
                print(splitedArray.count)
            
            
                for channel in splitedArray{
                    let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    let subscribeChannel = channel.stringByTrimmingCharactersInSet(whitespace)
                    if subscribeChannel != ""{
                        self.segment.subscribeArray?.append(subscribeChannel)
                        self.download.getSpiderData(subscribeChannel)
                    }
                    
                }
            }
            let tanNews = realm.objects(NewsData).filter("type = 7").sorted("createdAt", ascending: false)
            
            self.urlArray.removeAll()
            self.titleArray.removeAll()
            self.timeArray.removeAll()
            
            for new in tanNews{
                if self.titleArray.count <= 10{
                    self.titleArray.append(new.title)
                    self.timeArray.append(new.createdAt)
                    self.urlArray.append(new.url)
                }
                
                
            }

            self.tableView.reloadData()
        }

        
        
        userMan.userCallBackBlock { (user) in
            
            var channels = currentUser!.get("channels")?.JSONString
            if channels != nil{
                channels = channels!.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                channels = channels!.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                channels = channels!.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let splitedArray = channels!.componentsSeparatedByString(",")
                
                for channel in splitedArray{
                    
                    let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    let subscribeChannel = channel.stringByTrimmingCharactersInSet(whitespace)
                    let redPointChannel = splitedArray.last?.stringByTrimmingCharactersInSet(whitespace)
                    if subscribeChannel != ""{
                        if subscribeChannel == redPointChannel{
                            self.download.firstGetSpiderData(subscribeChannel,type: 1)
                        }
                        else{
                            self.download.firstGetSpiderData(subscribeChannel,type: 0)
                        }
                    }
                    
                }
                
                for channel in splitedArray{
                    
                    let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    let subscribeChannel = channel.stringByTrimmingCharactersInSet(whitespace)
                    if subscribeChannel != ""{
                        self.segment.subscribeArray?.append(subscribeChannel)
                    }
                    
                }
                
                                
            }
            
            let tanNews = realm.objects(NewsData).filter("type = 7").sorted("createdAt", ascending: false)
            
            
            self.titleArray.removeAll()
            self.timeArray.removeAll()
            self.urlArray.removeAll()
            
            for new in tanNews{
                if self.titleArray.count <= 10{
                    self.titleArray.append(new.title)
                    self.timeArray.append(new.createdAt)
                    self.urlArray.append(new.url)
                }
                
            }
            self.tableView.reloadData()

            
        }
        
        addUI()
        addNavigatonBar()
        setupSubview()
        


        

        
        
        
        

        
//        setUpTableViewData(titleArray, timeArray: timeArray, urlArray: urlArray)
        

        //setUpTableViewData(titleArray!, timeArray: timeArray!)
        
        //setUpTableViewData(self.titleArray, timeArray: self.timeArray)

        
        // Do any additional setup after loading the view, typically from a nib.

        
    }
    

    
    
    
    //初始化UI
    func addUI(){
        self.view.addSubview(segment)
        self.view.addSubview(updateSegment)
        self.view.addSubview(recommendSegment)
        self.view.addSubview(greyView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    //添加导航栏
    func addNavigatonBar(){
        
        self.navigationController?.navigationBar.translucent  = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
        self.title = "侦探狗"
        self.navigationController?.title = "情报夹"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    func setupSubview() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.registerClass(NewsTableViewCell.self, forCellReuseIdentifier: CellNews)
        
        
    }
    
//    func setUpTableViewData(titleArray : [String], timeArray : [NSDate], urlArray : [String]) {
//        
//        self.tableViewProtocol = TableviewProtocol()
//        self.tableViewProtocol!.titleArray = titleArray
//        self.tableViewProtocol!.timeArray = timeArray
//        self.tableViewProtocol!.urlArray = urlArray
//        self.tableView.delegate = self.tableViewProtocol
//        self.tableView.dataSource = self.tableViewProtocol
//        
//    }
    
    
    
    
    //点击Scrollview上的Button回调事件
    func buttonDidClicked(subscribe:String){
        if subscribe == "推荐" {
            let tanNews = realm.objects(NewsData).filter("type = 7").sorted("createdAt", ascending: false)
            
            self.titleArray.removeAll()
            self.timeArray.removeAll()
            self.urlArray.removeAll()
            
            for new in tanNews{
                if titleArray.count <= 10{
                    self.titleArray.append(new.title)
                    self.timeArray.append(new.createdAt)
                    self.urlArray.append(new.url)
                }
                
            }
            self.tableView.reloadData()
        }
        else{
            let tanNews = realm.objects(NewsData).filter("title CONTAINS '\(subscribe)'").sorted("createdAt", ascending: false)
            
            self.titleArray.removeAll()
            self.timeArray.removeAll()
            self.urlArray.removeAll()
            
            for new in tanNews{
                if titleArray.count <= 10{
                    self.titleArray.append(new.title)
                    self.timeArray.append(new.createdAt)
                    self.urlArray.append(new.url)
                }
                
                
            }
        }
        
        
//        setUpTableViewData(titleArray, timeArray: timeArray, urlArray: urlArray)
        
        tableView.reloadData()
        
    }
    
    func buttonDidLongPressed(index:Int) {
        
        
        let subscribe = segment.subscribeArray![index]
        if subscribe != "推荐" {
            let alertController = UIAlertController(title: "取消订阅", message: "是否取消订阅\(subscribe)", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: { (_) in
                if currentUser != nil{
                    self.userMan.followDelete(currentUser!, channel: subscribe)
                }
                self.segment.subscribeArray?.removeAtIndex(index)
                if nowIndex == 0 {
                    
                    let tanNews = realm.objects(NewsData).filter("type = 7").sorted("createdAt", ascending: false)
                    
                    self.titleArray.removeAll()
                    self.timeArray.removeAll()
                    self.urlArray.removeAll()
                    
                    for new in tanNews{
                        if self.titleArray.count <= 10{
                            self.titleArray.append(new.title)
                            self.timeArray.append(new.createdAt)
                            self.urlArray.append(new.url)
                        }
                        
                    }
                    
                    
                    
                }
                
                else if nowIndex == index{
                    
                    let tanNews = realm.objects(NewsData).filter("title CONTAINS '\(self.segment.subscribeArray![nowIndex-1])'").sorted("createdAt", ascending: false)
                    
                    self.titleArray.removeAll()
                    self.timeArray.removeAll()
                    self.urlArray.removeAll()
                    
                    for new in tanNews{
                        if self.titleArray.count <= 10{
                            self.titleArray.append(new.title)
                            self.timeArray.append(new.createdAt)
                            self.urlArray.append(new.url)
                        }
                        
                    }
                    
                }
                else{
                    
                    let tanNews = realm.objects(NewsData).filter("title CONTAINS '\(self.segment.subscribeArray![nowIndex])'").sorted("createdAt", ascending: false)
                    
                    self.titleArray.removeAll()
                    self.timeArray.removeAll()
                    self.urlArray.removeAll()
                    
                    for new in tanNews{
                        if self.titleArray.count <= 10{
                            self.titleArray.append(new.title)
                            self.timeArray.append(new.createdAt)
                            self.urlArray.append(new.url)
                        }
                        
                    }
                    
                }
                
                
                
                self.tableView.reloadData()

                
                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Success)
                
                view.button?.removeFromSuperview()
                
                view.configureDropShadow()
                view.configureContent(title: "成功", body: "取消订阅\(subscribe)成功啦")
                SwiftMessages.show(view: view)

                
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let view = MessageView.viewFromNib(layout: .CardView)
            
            view.configureTheme(.Warning)
            
            view.button?.removeFromSuperview()
            
            view.configureDropShadow()
            view.configureContent(title: "出错啦", body: "您不能取消订阅推荐喔")
            SwiftMessages.show(view: view)
        }
        
    }
    
    func recommendButtonDidClicked(recommend: String) {
        
        if segment.subscribeArray!.contains(recommend){
            
            let view = MessageView.viewFromNib(layout: .CardView)
            
            view.configureTheme(.Warning)
            
            view.button?.removeFromSuperview()
            
            view.configureDropShadow()
            view.configureContent(title: "出错啦", body: "您已经订阅过\(recommend)了")
            SwiftMessages.show(view: view)

        }
        else{
            download.getSpiderData(recommend)
            
            if currentUser != nil{
                
                userMan.followUpdate(currentUser!, channel: recommend)
                
            }
            
            segment.subscribeArray?.append(recommend)
            
        }
        
    }
    
    func updateButtonDidClicked(subscribe: String) {
        
        //去除前后空格
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let subscribeChannel = subscribe.stringByTrimmingCharactersInSet(whitespace)
        
        //检查是否为空
        if subscribeChannel != "" {
            
            //检查是否重复
            if segment.subscribeArray!.contains(subscribeChannel){
                
                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Warning)
                
                view.button?.removeFromSuperview()
                
                view.configureDropShadow()
                view.configureContent(title: "出错啦", body: "您已经订阅过\(subscribeChannel)了")
                SwiftMessages.show(view: view)
                
                
            }
            else{
                
                download.getSpiderData(subscribeChannel)
                
                if currentUser != nil{
                    
                    userMan.followUpdate(currentUser!, channel: subscribeChannel)
                    
                }
                
                segment.subscribeArray?.append(subscribeChannel)
                
                print("点击\(subscribeChannel)")
                
                
            }

            
        }
        else{
            
            let view = MessageView.viewFromNib(layout: .CardView)
            
            view.configureTheme(.Warning)
            
            view.button?.removeFromSuperview()
            
            view.configureDropShadow()
            view.configureContent(title: "出错啦", body: "请输入要订阅的内容喔")
            SwiftMessages.show(view: view)
            
        }
        
        
        
    }
    
    func refreshSubscribeSegment(){
        
        var channels = currentUser!.get("channels")!.JSONString
        channels = channels.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        channels = channels.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        channels = channels.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let splitedArray = channels.componentsSeparatedByString(",")
        for channel in splitedArray{
            let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
            let subscribeChannel = channel.stringByTrimmingCharactersInSet(whitespace)
            self.segment.subscribeArray?.append(subscribeChannel)
            self.download.getSpiderData(subscribeChannel)
            self.tableView.reloadData()
        }

        
    }
    
    func getRemoveIndex<T: Equatable>(value: T, array: [T]) -> [Int]{
        
        var indexArray = [Int]()
        var correctArray = [Int]()
        
        
        //获取指定值在数组中的索引
        for (index,_) in array.enumerate() {
            if array[index] == value {
                indexArray.append(index)
            }
        }
        
        //计算正确的删除索引
        for (index, originIndex) in indexArray.enumerate(){
            //指定值索引减去索引数组的索引
            var correctIndex = originIndex - index
            
            //添加到正确的索引数组中
            correctArray.append(correctIndex)
        }
        
        return correctArray
    }
    
    //从数组中删除指定元素
    func removeValueFromArray<T: Equatable>(value: T, inout array: [T]){
        
        var correctArray = getRemoveIndex(value, array: array)
        
        //从原数组中删除指定元素
        for index in correctArray{
            array.removeAtIndex(index)
        }
        
    }

    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if titleArray == [] {
            return 1
        }
        else{
            
            return titleArray.count
            
        }

            
        
        

        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellNews) as! NewsTableViewCell
        //NSDate转换为String
        
        if titleArray == [] {
            cell.titleLabel.text = "暂无新消息"
        }
        else {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let convertedDate = dateFormatter.stringFromDate(timeArray[indexPath.row])
            cell.timeLabel.text = convertedDate
            cell.titleLabel.text = titleArray[indexPath.row]
            
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
        
    }
    
    //点击cell时调用
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //print(urlArray![indexPath.row])
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if titleArray != []{
            
            let subscribeUrl = urlArray[indexPath.row]
            
            let subscribeTitle = titleArray[indexPath.row]
            
            self.hidesBottomBarWhenPushed = true
            
            let webView = WebViewController()
            
            webView.newTitle = subscribeTitle
            
            webView.urlencode = subscribeUrl
            
            self.navigationController?.pushViewController(webView, animated: true)
            
            self.hidesBottomBarWhenPushed = false
            
        }
        
        
        
    }
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateSegment.textBox.resignFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

