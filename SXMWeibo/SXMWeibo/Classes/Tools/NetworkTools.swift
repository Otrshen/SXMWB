//
//  NetworkTools.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/5.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

    // 单例
    static let shareInstance: NetworkTools = {
        SXMLog("a")
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        
        let instance = NetworkTools(baseURL: baseURL, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/plain", "text/javascript", "text/json") as? Set
        return instance
    }()
    
    // MARK: - 外部控制方法
    func loadStatuses(since_id: String, finished: (array: [[String: AnyObject]]?, error: NSError?)->()) {
        assert(UserAccount.loadUserAccount() != nil, "需授权")
        
        // 准备路径
        let path = "2/statuses/home_timeline.json"
        
        let parameters = ["access_token" : UserAccount.loadUserAccount()!.access_token!, "since_id" : since_id]
        GET(path, parameters: parameters, progress: nil, success: { (task, objc) -> Void in
            
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                finished(array: nil, error: NSError(domain: "sxmerror", code: 1000, userInfo: ["messge": "没有获取到数据"]))
                return
            }
            
            finished(array: arr, error: nil)
            
            }) { (task, error) -> Void in
                finished(array: nil, error: error)
        }
    }
}
