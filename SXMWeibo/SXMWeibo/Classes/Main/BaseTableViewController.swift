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
        
        visitorView?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension BaseTableViewController: VisitorViewDelegate {
    func visitorViewDidClickLoginBtn(visitor: VisitorView) {
        SXMLog("")
    }
    
    func visitorViewDidClickRegisterBtn(visitor: VisitorView) {
        SXMLog("")    
    }
}
