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
    var uid: String?
    
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
        // 归档
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    // 保存授权模型
    static var account: UserAccount?
    // 归档缓存路径
    static let filePath: String = "useraccount.plist".cacheDir()
    
    // 解
    class func loadUserAccount() -> UserAccount? {
        
        if UserAccount.account != nil {
            return nil
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
        SXMLog(account.expires_Date)
        SXMLog(NSDate())
        guard let date = account.expires_Date where date.compare(NSDate()) == NSComparisonResult.OrderedAscending else {
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
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
    }

}
