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
        let otherView = VisitorView.visitorView()
        view = otherView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
