//
//  HomeTableViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回到这里看看有什么惊喜")
            return
        }
        
        setupNav()
    }
    
    // MARK: - 内部控制方法
    private func setupNav()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: Selector("leftBtnClick"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: Selector("rightBtnClick"))
        
        // 2.添加标题按钮
        let titleButton = TitleButton()
        titleButton.setTitle("LarkNan", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
    }
    
    @objc private func titleBtnClick(btn: TitleButton) {
        btn.selected = !btn.selected
    }
    
    @objc private func leftBtnClick() {
        SXMLog("")
    }
    
    @objc private func rightBtnClick() {
        SXMLog("")
    }
}
