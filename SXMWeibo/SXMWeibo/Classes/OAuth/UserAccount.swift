//
//  UserAccount.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/5.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {

    var access_token: String?
    // 从授权开始 多少秒之后过期时间
    var expires_in: Int = 0 {
        didSet {
            expires_Date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    // 真正过期时间
    var expires_Date: NSDate?
    // 用户ID
    var uid: String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        // 如果要想初始化方法中使用KVC必须先调用super.init初始化对象
        // 如果属性是基本数据类型, 那么建议不要使用可选类型, 因为基本数据类型的可选类型在super.init()方法中不会分配存储空间
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // KVC发现没有对应key是就会调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["access_token", "expires_in", "uid"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
    
    // MRAK: - 外部控制方法
    // 归档
    func saveAccount() -> Bool {
        SXMLog("归档路径：\(UserAccount.filePath)")
        // 归档
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    // 保存授权模型
    static var account: UserAccount?
    // 归档缓存路径
    static let filePath: String = "useraccount.plist".cacheDir()
    
    // 解
    class func loadUserAccount() -> UserAccount? {
        SXMLog("归档路径：\(UserAccount.filePath)")
        if UserAccount.account != nil {
            return UserAccount.account 
        }
        
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount else {
            return UserAccount.account
        }
        
        // 校验是否过期了
        /*
        guard let date = account.expires_Date else {
            return nil
        }
        if date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return nil
        }
        */

        guard let date = account.expires_Date where date.compare(NSDate()) != NSComparisonResult.OrderedAscending else {
            SXMLog("过期了")
            return nil
        }
        
        UserAccount.account = account
        
        return UserAccount.account
    }
    
    // 判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    // 获取用户信息
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?) -> ()) {
        // 断言
        assert(access_token != nil, "使用方法必须先授权")
        
        let path = "2/users/show.json"
        let parameters = ["access_token" : access_token!, "uid" : uid!]
        
        NetworkTools.shareInstance.GET(path, parameters: parameters, success: { (task, objc) -> Void in
            let dict = objc as! [String: AnyObject]
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            
            finished(account: self, error: nil)
            
            SXMLog(objc)
            }) { (task, error) -> Void in
                SXMLog(error)
                finished(account: nil, error: error)
        }
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }

}
