//
//  HomeTableViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回到这里看看有什么惊喜")
            return
        }
        
        setupNav()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: SXMPresentationManagerDidPresented, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: SXMPresentationManagerDidDismissed, object: animatorManager)
        
        // 获取微博数据
        loadData()
    }
    
    
    // MARK: - 内部控制方法
    private func loadData() {
        NetworkTools.shareInstance.loadStatuses { (array, error) -> () in
            if error != nil {
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
                SVProgressHUD.showErrorWithStatus("获取微博数据失败")
                return
            }
            
            guard let arr = array else {
                return
            }
            
            // 将字典数组转换为模型数组
            var models = [Status]()
            for dict in arr {
                let status = Status(dict: dict)
                models.append(status)
            }
            
            SXMLog(models)
        }
    }
    
    private func setupNav() {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: Selector("leftBtnClick"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: Selector("rightBtnClick"))
        
        // 2.添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    @objc private func leftBtnClick() {
        SXMLog("")
    }
    
    // 二维码
    @objc private func rightBtnClick() {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @objc private func titleChange () {
        titleButton.selected = !titleButton.selected
    }
    
    @objc private func titleBtnClick(btn: TitleButton) {
        // 显示菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        
        // 设置转场代理
        menuView.transitioningDelegate = animatorManager
        // 设置转场动画
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - lazy
    private lazy var animatorManager: SXMPresentationManager = {
        let manager = SXMPresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 400)
        return manager
    }()
    
    private lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}
