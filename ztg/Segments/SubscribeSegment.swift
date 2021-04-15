//
//  SubscribeSegment.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/22.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit

protocol subscribeSegementDelegate : class {
    
    func buttonDidClicked(subscribe:String)
    func buttonDidLongPressed(index:Int)
    
}

class SubscribeSegment: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var delegate : subscribeSegementDelegate?
    
    let buttonTagBase = 100
    
    var index : Int = 100
    
    var longPressTag = 100
    
    
    var subscribeArray : Array<String>?{
        
        didSet{
            
            createSubscribeViews()
            
        }
    
    }
    
    lazy var imageView:UIImageView = {
        
        let temp = UIImageView()
        temp.image = UIImage(named:"ic_focus.png")
        
        return temp
        
    }()
    
    lazy var labelView:UILabel = {
        
        let temp = UILabel()
        temp.textColor = UIColor.grayColor()
        temp.text = "您正在追踪(左右滑动标签，长按取消定制)"
        temp.font = UIFont.systemFontOfSize(14)
        
        return temp
        
    }()
    
    lazy var scrollView:UIScrollView = {
        
        let temp = UIScrollView()
        temp.showsHorizontalScrollIndicator = false
        
        return temp
        
    } ()
    

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.scrollView.frame = CGRectMake(0, 0.41666*frame.size.height, frame.size.width, frame.size.height*0.75)
        self.imageView.frame = CGRectMake(15, 0, frame.size.height*0.25, frame.size.height*0.25)
        self.labelView.frame = CGRectMake(32, 0, frame.size.width-30, frame.size.height*0.25)
        self.addSubview(scrollView)
        self.addSubview(imageView)
        self.addSubview(labelView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //生成button
    func createSubscribeViews(){
        
        for subview in self.scrollView.subviews {
            
            subview.removeFromSuperview()
            
        }
        
        if let count = subscribeArray?.count{
            
            let width:CGFloat = (frame.size.width-75)/4
            
            for i in 0..<count{
                
                //生成button样式
                let subscribeButton = UIButton()
                subscribeButton.layer.cornerRadius = 5
                subscribeButton.layer.borderColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1).CGColor
                subscribeButton.layer.borderWidth = 1
                
                //生成button位置
                subscribeButton.frame = CGRectMake(CGFloat(i)*width+15*CGFloat(i)+CGFloat(15), 0, width, 0.666*frame.size.height)
                
                longPressTag = subscribeButton.tag
                //button事件
                subscribeButton.addTarget(self, action: #selector(buttonClicked(button:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                let longpressGesutre = UILongPressGestureRecognizer(target: self, action: "longTap:")
                subscribeButton.addGestureRecognizer(longpressGesutre)
                
                subscribeButton.tag = i + buttonTagBase
                
                subscribeButton.setTitleColor(UIColor.whiteColor(), forState:.Selected)
                
                subscribeButton.setTitleColor(UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1), forState:.Normal)
                
                subscribeButton.titleLabel?.font = UIFont.systemFontOfSize(16)
                
                if let subscribe = subscribeArray?[i]{
                    
                    subscribeButton.setTitle(subscribe, forState: UIControlState.Normal)
                    if hasNewNews != []{
                        if hasNewNews.contains(subscribe){
                            
                            let redPoint = UIView.init(frame:CGRectMake(width-10, 2, 8, 8))
                            redPoint.backgroundColor = UIColor.redColor()
                            redPoint.layer.cornerRadius = 5
                            subscribeButton.addSubview(redPoint)
                            
                        }
                    }
                    
                    self.scrollView.addSubview(subscribeButton)
                    
                }
                
                if i + buttonTagBase == self.index{
                    
                    subscribeButton.selected = true
                    
                }
                
                
                //设置button背景色
                if subscribeButton.selected == true{
                    subscribeButton.backgroundColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
                }
                else{
                    
                    subscribeButton.backgroundColor = UIColor.whiteColor()
                    
                }
                
            }
            
            //设置scrollview可滑动范围
            scrollView.contentSize = CGSizeMake((width+15)*(CGFloat(count))+15, self.frame.size.height-20)
            
        }
        
    }
    
    
    //按钮点击事件
    func buttonClicked(button button:UIButton) {
        
        if let tempButton = self.scrollView.viewWithTag(self.index) as? UIButton{
            
            tempButton.selected = false
            //设置button背景色
            if tempButton.selected == true{
                
                tempButton.backgroundColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
                
            }
            else{
                
                tempButton.backgroundColor = UIColor.whiteColor()
                
            }
            
            
        }
        for v: UIView in button.subviews as [UIView] {
            if v.backgroundColor == UIColor.redColor(){
                v.removeFromSuperview()
                if let hasNewNewsTitle = button.titleLabel?.text{
                    removeValueFromArray(hasNewNewsTitle, array: &hasNewNews)
                }
            }
            
        }
        
        print(hasNewNews)


        button.selected = true
        self.delegate?.buttonDidClicked(subscribeArray![button.tag - buttonTagBase])
        self.index = button.tag
        //设置button背景色
        if button.selected == true{
            button.backgroundColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
        }
        else{
            
            button.backgroundColor = UIColor.whiteColor()
            
        }
        nowIndex = button.tag - buttonTagBase
        
    }
    
    
    func longTap(sender : UIGestureRecognizer){
        let button = sender.view as! UIButton
        
        if sender.state == .Ended{
            
            self.delegate?.buttonDidLongPressed(button.tag - buttonTagBase)
            
        }
        else{
            
            return
            
        }
        
        
    }
    
    //获取正确的删除索引
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


}
