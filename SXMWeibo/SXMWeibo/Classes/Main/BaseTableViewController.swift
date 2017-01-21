//
//  BaseTableViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/11.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    var isLogin = false
    var visitorView: VisitorView?
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    private func setupVisitorView() {
        visitorView = VisitorView.visitorView()
        view = visitorView
        
        visitorView?.loginButton.addTarget(self, action: Selector("loginBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        visitorView?.registerButton.addTarget(self, action: Selector("registerBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("loginBtnClick:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("registerBtnClick:"))
    }
    
    @objc private func loginBtnClick(btn: UIButton) {
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @objc private func registerBtnClick(btn: UIButton) {
        SXMLog("")        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
