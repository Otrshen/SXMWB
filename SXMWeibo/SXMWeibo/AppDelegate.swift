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
        
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.backgroundColor = UIColor.whiteColor()
//        window?.rootViewController = MainViewController()
//        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        return true
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

func SXMLog<T>(message : T, fileName : String = __FILE__, methodName : String = __FUNCTION__, lineNumber : Int = __LINE__)
{
    #if DEBUG
    let filename = (fileName as NSString).pathComponents.last
    print("\(filename!).\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

