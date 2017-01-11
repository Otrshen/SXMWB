//
//  MainViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        
        // 设置加号按钮的位置
        let rect = composeButton.frame
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
//        composeButton.frame = CGRectOffset(rect, 2 * width, 0)
    }
    

    // MARK: - 懒加载
    lazy var composeButton : UIButton = {
        () -> UIButton in
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        btn.addTarget(self, action: Selector("composeBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    @objc private func composeBtnClick() {
        SXMLog("a")
    }
    
}
