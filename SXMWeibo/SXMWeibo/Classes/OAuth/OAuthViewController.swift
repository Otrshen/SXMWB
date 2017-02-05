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

extension OAuthViewController: UIWebViewDelegate {
    // 每次请求都会调用 false：不允许请求 true：允许请求
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        SXMLog(request)
        // 判断是否是授权回调页
        guard let urlStr = request.URL?.absoluteString else {
            return false
        }
        
        if !urlStr.hasPrefix("http://www.520it.com") {
            return true
        }
        
        let key = "code="
        // 判断回调地址是否包含code
        if urlStr.containsString(key) {
            let code = request.URL!.query?.substringFromIndex(key.endIndex)

            loadAccessToken(code)
            return false
        }
        
        return false
    }
    
    // 换取accessToken
    private func loadAccessToken(codeStr: String?) {
        guard let code = codeStr else {
            return
        }
        
        // 准备请求路径
        let path = "oauth2/access_token"
        // 构建参数
        let parameters = ["client_id" : "528023216", "client_secret" : "0c0ef1c5c08f7e22d06aa9cd985fedbe", "grant_type" : "authorization_code", "code" : code, "redirect_uri" : "http://www.520it.com"]
        
        NetworkTools.shareInstance.POST(path, parameters: parameters, success: { (task: NSURLSessionDataTask?, dictStr: AnyObject?) -> Void in
            guard let dict = dictStr else {
                return
            }
            SXMLog(dict)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                SXMLog(error)
        }
        
    }
}
