//
//  Status.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class Status: NSObject {
    /* 微博创建时间 */
    var created_at: String?
    /* 字符串型的微博ID */
    var idstr: String?
    /* 微博信息内容 */
    var text: String?
    /* 微博来源 */
    var source: String?
    /* 微博作者的用户信息 */
    var user: User?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // KVC的setValuesForKeysWithDictionary方法内部会调用setValue方法
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            user = User(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["created_at", "idstr", "text", "source"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
