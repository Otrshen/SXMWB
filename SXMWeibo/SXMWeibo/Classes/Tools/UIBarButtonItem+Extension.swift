//
//  UIBarButtonItem+Extension.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/15.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /**
     自定义方法
     
     - parameter imageName: <#imageName description#>
     - parameter target:    <#target description#>
     - parameter action:    <#action description#>
     
     - returns: <#return value description#>
     */
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        self.init(customView: btn)
    }
}