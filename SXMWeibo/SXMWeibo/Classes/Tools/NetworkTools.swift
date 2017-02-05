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
        
        instance.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as? Set
        return instance
    }()
    
  
}
