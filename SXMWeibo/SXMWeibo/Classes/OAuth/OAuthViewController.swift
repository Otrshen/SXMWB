//
//  OAuthViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/21.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    // 网页容器
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=528023216&redirect_uri=http://www.520it.com"
        guard let url = NSURL(string: urlStr) else {
            return
        }
        let request = NSURLRequest(URL: url)
        customWebView.loadRequest(request)
    }
}
