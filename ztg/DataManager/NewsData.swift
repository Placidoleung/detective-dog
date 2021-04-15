//
//  NewsData.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/1.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import Foundation
import RealmSwift

class NewsData: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var objectID:String = ""
    dynamic var createdAt = NSDate()
    dynamic var url:String = ""
    dynamic var title:String = ""
    dynamic var type:Double = 0
    
}

