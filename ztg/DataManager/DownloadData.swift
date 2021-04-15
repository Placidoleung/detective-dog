//
//  DownloadData.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/8.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import Foundation
import LeanCloud
import RealmSwift
import SwiftMessages

typealias RedPointClosure = (String)->Void

class DownloadData {
    
    var redPointBackValueClosure : RedPointClosure?
    
    
    
    func getRecommendData(){
        
        let query = LCQuery(className: "SpiderData")
        
        query.whereKey("title", .Selected)
        query.whereKey("url", .Selected)
        query.whereKey("objectId", .Selected)
        query.whereKey("type", .Selected)
        query.whereKey("type", .EqualTo(LCNumber(7)))
        query.whereKey("createdAt", .Selected)
        query.whereKey("createdAt", .Descending)
        query.limit = 10
        query.find { result in
            switch result {
            case .Success(let todos):
                try! realm.write{
                    for todo in todos{
                        var News = NewsData()
                        News.objectID = (todo.get("objectId") as! LCString).value
                        News.title = (todo.get("title") as! LCString).value
                        News.url = (todo.get("url") as! LCString).value
                        News.type = (todo.get("type") as! LCNumber).value
                        News.createdAt = (todo.get("createdAt") as! LCDate).value
                        News = NewsData(value: [News.objectID ,News.createdAt, News.url, News.title, News.type])
                        let tanNews = realm.objects(NewsData).filter("objectID = \"\(News.objectID)\"")
                        if tanNews.count == 0{
                            realm.add(News)
                            
                        }
                        
                        
                    }
                    
                }
            break // 查询成功
            case .Failure(let error):
                print(error)
            }
            
        }

        
    }
    
    func getSpiderData(subscribeChannel:String){
        
        let query = LCQuery(className: "SpiderData")
        
        query.whereKey("title", .Selected)
        query.whereKey("title", .MatchedSubstring(subscribeChannel))
        query.whereKey("url", .Selected)
        query.whereKey("objectId", .Selected)
        query.whereKey("type", .Selected)
        query.whereKey("createdAt", .Selected)
        query.whereKey("createdAt", .Descending)
        query.limit = 10
        
        query.find { result in
            switch result {
            case .Success(let todos):
                try! realm.write{
                    for todo in todos{
                        var News = NewsData()
                        News.objectID = (todo.get("objectId") as! LCString).value
                        News.title = (todo.get("title") as! LCString).value
                        News.url = (todo.get("url") as! LCString).value
                        News.type = (todo.get("type") as! LCNumber).value
                        News.createdAt = (todo.get("createdAt") as! LCDate).value
                        News = NewsData(value: [News.objectID ,News.createdAt, News.url, News.title, News.type])
                        let tanNews = realm.objects(NewsData).filter("objectID = \"\(News.objectID)\"")
                        if tanNews.count == 0{
                            realm.add(News)

                            
                        }
                        
                        
                    }
                    
                }
                
                //                try! realm.write{
                //
                //                    for NewsSet in NewsSets{
                //                        let tanNews = realm.objects(NewsData).filter("objectID = \"\(NewsSet.objectID)\"")
                //                        if tanNews.count == 0{
                //                            realm.add(NewsSet)
                //                            if hasNewNews.contains(subscribeChannel) == false{
                //
                //                                hasNewNews.append(subscribeChannel)
                //
                //                            }
                //
                //
                //                        }
                //
                //
                //                    }
                //                }
            break // 查询成功
            case .Failure(let error):
                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Error)
                
                view.button?.removeFromSuperview()
                
                view.configureDropShadow()
                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                view.configureContent(title: "出错啦", body: "加载新闻列表失败", iconText: iconText)
                
                // Show the message.
                SwiftMessages.show(view: view)
            }
            
        }
        
        
        
        
    }

    
    func firstGetSpiderData(subscribeChannel:String,type:Int){
        
        let query = LCQuery(className: "SpiderData")
        
        query.whereKey("title", .Selected)
        query.whereKey("title", .MatchedSubstring(subscribeChannel))
        query.whereKey("url", .Selected)
        query.whereKey("objectId", .Selected)
        query.whereKey("type", .Selected)
        query.whereKey("createdAt", .Selected)
        query.whereKey("createdAt", .Descending)
        query.limit = 10

        query.find { result in
            switch result {
            case .Success(let todos):
                try! realm.write{
                    for todo in todos{
                        var News = NewsData()
                        News.objectID = (todo.get("objectId") as! LCString).value
                        News.title = (todo.get("title") as! LCString).value
                        News.url = (todo.get("url") as! LCString).value
                        News.type = (todo.get("type") as! LCNumber).value
                        News.createdAt = (todo.get("createdAt") as! LCDate).value
                        News = NewsData(value: [News.objectID ,News.createdAt, News.url, News.title, News.type])
                        let tanNews = realm.objects(NewsData).filter("objectID = \"\(News.objectID)\"")
                        if tanNews.count == 0{
                            realm.add(News)

                            if hasNewNews.contains(subscribeChannel) == false{
                                
                                hasNewNews.append(subscribeChannel)
                                
                            }
                            
                            
                        }

                        
                    }
                    if type == 1{
                        
                        if self.redPointBackValueClosure != nil {
                            self.redPointBackValueClosure!("refreshUI")
                        }
                        
                    }
                    
                }
                
                
                
//                try! realm.write{
//                    
//                    for NewsSet in NewsSets{
//                        let tanNews = realm.objects(NewsData).filter("objectID = \"\(NewsSet.objectID)\"")
//                        if tanNews.count == 0{
//                            realm.add(NewsSet)
//                            if hasNewNews.contains(subscribeChannel) == false{
//                                
//                                hasNewNews.append(subscribeChannel)
//                                
//                            }
//                            
//                            
//                        }
//
//                        
//                    }
//                }
            break // 查询成功
            case .Failure(let error):
                let view = MessageView.viewFromNib(layout: .CardView)
                
                view.configureTheme(.Error)
                
                view.button?.removeFromSuperview()
                
                view.configureDropShadow()
                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                view.configureContent(title: "出错啦", body: "加载新闻列表失败", iconText: iconText)
                
                // Show the message.
                SwiftMessages.show(view: view)
            }
            
        }
        
        
        
        
    }
    
}
