//
//  TableviewProtocol.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/12/2.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit

let CellNews  = "NewsTableViewCell"


class TableviewProtocol: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var titleArray : [String]?
    var timeArray : [NSDate]?
    var urlArray : [String]?
    let view = ViewController()
    let webView = WebViewController()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.titleArray?.count {
            
            return count
            
        }
        
        print(titleArray)
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellNews) as! NewsTableViewCell
        //NSDate转换为String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let convertedDate = dateFormatter.stringFromDate(timeArray![indexPath.row])
        
        cell.timeLabel.text = convertedDate
        cell.titleLabel.text = titleArray![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //print(urlArray![indexPath.row])
        
        let subscribeUrl = urlArray![indexPath.row]
        
        
        
    }
    
    
}
