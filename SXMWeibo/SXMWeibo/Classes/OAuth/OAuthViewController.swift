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

        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_key)&redirect_uri=\(WB_Redirect_uri)"
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
        
        if !urlStr.hasPrefix(WB_Redirect_uri) {
            return true
        }
        
        let key = "code="
        guard let str = request.URL!.query else {
            return false
        }
        // 判断回调地址是否包含code
        if str.hasPrefix(key) {
            let code = str.substringFromIndex(key.endIndex)

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
        let parameters = ["client_id" : WB_App_key, "client_secret" : WB_App_Secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : WB_Redirect_uri]
        
        NetworkTools.shareInstance.POST(path, parameters: parameters, success: { (task: NSURLSessionDataTask?, dictStr: AnyObject?) -> Void in
            guard let objc = dictStr else {
                return
            }
            
            /* 
            {
            "access_token" = "2.00BsOWQD0UxWjZebf57b3dcaXApzGC";
            "expires_in" = 157679999;
            "remind_in" = 157679999;
            uid = 2992503533;
            }
            */

            let account = UserAccount(dict: objc as! [String : AnyObject])
            
            account.loadUserInfo({ (account, error) -> () in
                account?.saveAccount()
            })
            
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                SXMLog(error)
        }
        
    }
}
