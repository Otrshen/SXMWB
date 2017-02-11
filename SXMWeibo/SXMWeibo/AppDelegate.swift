//
//  AppDelegate.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import QorumLogs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 注册监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeRootViewController:"), name: SXMSwichRootViewController, object: nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()

        
        SXMLog(UserAccount.loadUserAccount())
        SXMLog(isNewVersion())
        
        return true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {

    }
}

extension AppDelegate {
    
    /**
     切换根控制器
     */
    func changeRootViewController(notice: NSNotification) {
        if notice.object as! Bool {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()
        } else {
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()
        }
    }
    
    /**
        返回默认界面
     */
    private func defaultViewController() -> UIViewController {
        // 判断是否登录
        if UserAccount.isLogin() {
            
            if isNewVersion() {
                return UIStoryboard(name: "Newfeature", bundle: nil).instantiateInitialViewController()!
            } else {
                return UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController()!
            }
        }
        
        // 没有登录
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    /**
     判断是否有新版本
     */
    private func isNewVersion() -> Bool {
        // 加载info.list
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let sanboxVersion = (defaults.objectForKey("oldVersion") as? String) ?? "0.0"
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending {
            SXMLog("有现版本")
            // 如果有新版本，更新本地版本号
            
            defaults.setObject(currentVersion, forKey: "oldVersion")
            return true
        }
        SXMLog("没有新版本")
        return false
    }
}

func SXMLog<T>(message : T, fileName : String = __FILE__, methodName : String = __FUNCTION__, lineNumber : Int = __LINE__)
{
    #if DEBUG
    let filename = (fileName as NSString).pathComponents.last
    print("\(filename!).\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

