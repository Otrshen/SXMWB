//
//  UIButton+Extension.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/10.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

extension UIButton {
    
    /*
        如果构造方法前面没有convenience单词, 代表着是一个初始化构造方法(指定构造方法)
        如果构造方法前面有convenience单词, 代表着是一个便利构造方法
        指定构造方法和便利构造方法的区别
        指定构造方法中必须对所有的属性进行初始化
        便利构造方法中不用对所有的属性进行初始, "因为便利构造方法依赖于指定构造方法"
        一般情况下如果想给系统的类提供一个快速创建的方法, 就自定义一个便利构造方法
    */
    convenience init(imageName: String?, backgroundImageName: String?) {
        self.init()
        
        if let name = imageName {
            setImage(UIImage(named: name), forState: UIControlState.Normal)
            setImage(UIImage(named: name + "_highlighted"), forState: UIControlState.Highlighted)
        }
        
        if let backgroundName = backgroundImageName {
            setBackgroundImage(UIImage(named: backgroundName), forState: UIControlState.Normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), forState: UIControlState.Highlighted)
        }
    
        sizeToFit()
    }
}