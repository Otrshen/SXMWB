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
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["created_at", "idstr", "text", "source"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
