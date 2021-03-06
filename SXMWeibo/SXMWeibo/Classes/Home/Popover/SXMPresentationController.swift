//
//  SXMPresentationController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/15.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class SXMPresentationController: UIPresentationController {
    
    // 菜单尺寸
    var presentFrame = CGRectZero

    /*
    1.如果不自定义转场modal出来的控制器会移除原有的控制器
    2.如果自定义转场modal出来的控制器不会移除原有的控制器
    3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
    4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
    5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
    6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
    */
    
    // 布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews() {
        // 设置弹出视图尺寸
        presentedView()?.frame = presentFrame
//        presentedView()?.frame = CGRect(x: 100, y: 45, width: 200, height: 200)
        
        // 添加蒙版
        containerView?.insertSubview(coverButton, atIndex: 0)
        coverButton.addTarget(self, action: Selector("coverBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @objc private func coverBtnClick() {
        SXMLog("")
        // 让菜单消失
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - lazy
    private lazy var coverButton: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.mainScreen().bounds
        btn.backgroundColor = UIColor.clearColor()
        return btn
    }()
}
