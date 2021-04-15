//
//  NewsTableViewCell.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/12/1.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit
import SnapKit

class NewsTableViewCell: UITableViewCell {
    

    lazy var titleLabel : UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFontOfSize(15)
        temp.textColor = UIColor.grayColor()
        return temp
        
    }()
    
    lazy var timeLabel : UILabel = {
        
        let temp = UILabel()
        temp.font = UIFont.systemFontOfSize(12)
        temp.textColor = UIColor.init(colorLiteralRed: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1)
        return temp
        
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            
            make.top.left.right.equalTo(self.contentView).inset(UIEdgeInsetsMake(5, 15, 0, 15))
            
        }
        
        timeLabel.snp_makeConstraints { (make) in
            
            make.left.equalTo(self.contentView).offset(15)
            make.bottom.equalTo(self.contentView).offset(-5)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
