//
//  TigerSegment.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/12/13.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit

protocol tigerSegmentDelegate : class {
    
    func tigerButtonDidClicked()
    
}

class TigerSegment: UIView {
    
    weak var delegate : tigerSegmentDelegate?
    
    lazy var image: UIImageView = {
        
        let temp = UIImageView()
        temp.image = UIImage(named:"ic_laohuzhengjuan.png")
        return temp
        
    }()
    
    lazy var recommendImage: UIImageView = {
        
        let temp = UIImageView()
        temp.image = UIImage(named:"ic_belt.png")
        return temp
        
    }()
    
    lazy var nameTitle: UILabel = {
        
        let temp = UILabel()
        temp.text = "老虎证券"
        temp.font = UIFont.boldSystemFontOfSize(17)
        return temp
        
    }()
    
    lazy var recommendTitle: UILabel = {
        
        let temp = UILabel()
        temp.textColor = UIColor.grayColor()
        temp.text = "推荐理由:美股投资利器"
        temp.font = UIFont.systemFontOfSize(14)
        return temp
        
    }()
    
    lazy var earnButton: UIButton = {
        
        let temp = UIButton()
        temp.backgroundColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
        temp.layer.cornerRadius = 5
        temp.titleLabel?.font = UIFont.systemFontOfSize(14)
        temp.setTitle("去赚钱", forState: .Normal)
        temp.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return temp
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.image.frame = CGRectMake(0.05*frame.size.width, 0.245*frame.size.height, 0.78*frame.size.height, 0.51*frame.size.height)
        self.recommendImage.frame = CGRectMake(0, 0, 0.62*frame.size.height, 0.44*frame.size.height)
        self.nameTitle.frame = CGRectMake(0.08*frame.size.width+0.78*frame.size.height, 0.23*frame.size.height, 0.5*frame.size.width, 0.25*frame.size.height)
        self.recommendTitle.frame = CGRectMake(0.08*frame.size.width+0.78*frame.size.height, 0.53*frame.size.height, 0.5*frame.size.width, 0.25*frame.size.height)
        self.earnButton.frame = CGRectMake(0.78*frame.size.width, 0.32*frame.size.height, 0.18*frame.size.width, 0.35*frame.size.height)
        self.earnButton.addTarget(self, action: #selector(tigerButtonClicked), forControlEvents: .TouchUpInside)
        self.addSubview(earnButton)
        self.addSubview(recommendTitle)
        self.addSubview(nameTitle)
        self.addSubview(image)
        self.addSubview(recommendImage)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tigerButtonClicked(){
        
        self.delegate?.tigerButtonDidClicked()
        
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
