//
//  UpdateSubscribeSegment.swift
//  ztg
//
//  Created by 梁鹏皓 on 16/11/28.
//  Copyright © 2016年 ClickOn. All rights reserved.
//

import UIKit

protocol updateSubscribeSegementDelegate : class {
    
    func updateButtonDidClicked(subscribe:String)
    
}

class UpdateSubscribeSegment: UIView, UITextFieldDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let userMan = UserManage()
    let view = ViewController()
    let download = DownloadData()
    
    weak var delegate : updateSubscribeSegementDelegate?
    
    lazy var updateButton : UIButton = {
        
        let temp = UIButton()
        temp.backgroundColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1)
        temp.setTitle("定制", forState: .Normal)
        temp.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return temp
        
        
    }()
    
    lazy var textBox : UITextField = {
        
        let temp = UITextField()
        temp.placeholder = "请输入您想追踪的信息..."
        temp.layer.borderColor = UIColor.init(colorLiteralRed: 40.0/255.0, green: 141.0/255.0, blue: 219.0/255.0, alpha: 1).CGColor
        temp.layer.borderWidth = 1
        
        return temp
        
        
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.updateButton.frame = CGRectMake(15+(frame.size.width-30)*0.75, 0, (frame.size.width-30)*0.25, frame.size.height)
        self.textBox.frame = CGRectMake(15, 0, (frame.size.width-30)*0.75, frame.size.height)
        updateButton.addTarget(self, action: #selector(updateButtonClicked(button:)), forControlEvents: .TouchUpInside)
  
        
        self.addSubview(updateButton)
        self.addSubview(textBox)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    //点击确定回调事件
    func updateButtonClicked(button button:UIButton){
        
        let subscribe = textBox.text! as String
        
        textBox.text?.removeAll()
        
        textFieldShouldReturn(textBox)
        
        self.delegate?.updateButtonDidClicked(subscribe)
        
        
    }

}
