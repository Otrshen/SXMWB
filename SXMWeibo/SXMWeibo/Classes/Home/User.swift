//
//  User.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class User: NSObject {
    /* 字符串型的用户UID */
    var idstr: String?
    /* 用户昵称 */
    var screen_name: String?
    /* 用户头像地址（中图），50×50像素 */
    var profile_image_url: String?
    /* 认证类型 */
    var verified_type: Int = -1
//    /* 是否是微博认证用户 true：是，false：否*/
//    var verified: Bool = false
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["idstr", "screen_name", "profile_image_url", "verified_type"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
