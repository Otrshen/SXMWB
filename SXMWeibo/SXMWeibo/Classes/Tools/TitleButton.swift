//
//  TitleButton.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/15.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // 通过XIB/SB创建时调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI() 
    }

    private func setupUI() {
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        sizeToFit()
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        // ?? 用户判断前面的参数是否是nil， 如果是nil就返回?? 后面的数据，如果不是nil那么??后面的语句不执行
        super.setTitle((title ?? "") + " ", forState: state)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 和OC不太一样, Swift语法允许我们直接修改一个对象的结构体属性的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
    }
}
