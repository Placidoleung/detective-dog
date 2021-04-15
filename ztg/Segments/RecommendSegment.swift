//
//  RecommendSegment.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/29.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit

protocol recommendSegmentDelegate : class {
    
    func recommendButtonDidClicked(recommend:String)
    
}

class RecommendSegment: UIView {
    
    weak var delegate : recommendSegmentDelegate?
    
    var recommendArray : Array<String>?{
        
        didSet{
            
            createRecommendViews()
            
        }
        
    }
    
    var testArray : Array<String> = []
    
    lazy var imageView:UIImageView = {
        
        let temp = UIImageView()
        temp.image = UIImage(named:"ic_tag.png")
        
        return temp
        
    }()
    
    lazy var labelView:UILabel = {
        
        let temp = UILabel()
        temp.textColor = UIColor.grayColor()
        temp.text = "这里有一些热门标签（点击可以直接添加）"
        temp.font = UIFont.systemFontOfSize(14)
        
        return temp
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.imageView.frame = CGRectMake(15, 0, 0.15*frame.size.height, 0.15*frame.size.height)
        self.labelView.frame = CGRectMake(32, 0, frame.size.width-30, 0.15*frame.size.height)
        self.addSubview(imageView)
        self.addSubview(labelView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRecommendViews(){
        
        
        if let count = recommendArray?.count{
            
            let width:CGFloat = (frame.size.width-75)/4
            
            for i in 0..<count{
                
                //生成button样式
                let recommendButton = UIButton()
                recommendButton.titleLabel?.font = UIFont.systemFontOfSize(16)
                recommendButton.layer.cornerRadius = 5
                recommendButton.layer.borderColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1).CGColor
                recommendButton.layer.borderWidth = 1

                
                //生成button位置
                //第一行button
                if i <= 3{
                    
                    recommendButton.frame = CGRectMake(CGFloat(i)*width+15*CGFloat(i)+CGFloat(15), frame.size.height*0.25, width, 0.375*frame.size.height)
                    

                }
                //第二行button
                else{
                    
                    recommendButton.frame = CGRectMake(CGFloat(i-4)*width+15*CGFloat(i-4)+CGFloat(15), 0.675*frame.size.height, width, 0.375*frame.size.height)
                    
                }
                

                
                
                recommendButton.tag = i
                
                recommendButton.addTarget(self, action: #selector(recommendButtonClicked(button:)), forControlEvents: .TouchUpInside)
                
                recommendButton.setTitleColor(UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1), forState:.Normal)
                
                //设置button文字
                if let recommend = recommendArray?[i]{
                    
                    recommendButton.setTitle(recommend, forState: UIControlState.Normal)
                    self.addSubview(recommendButton)
                    
                }
                
            }
            
        }
        
    }
    
    func recommendButtonClicked(button button:UIButton){
        
        self.delegate?.recommendButtonDidClicked(recommendArray![button.tag])
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
