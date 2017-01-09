//
//  MainViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orangeColor()
        
        addChildViewControllers()
    }
    
    func addChildViewControllers() {
//        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
//        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
//        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
//        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
        
        addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
    }
    
//    func addChildViewController(childController: UIViewController, title : String, imageName : String) {
    func addChildViewController(childControllerName: String, title : String, imageName : String) {
        
        // 动态获取命名空间
        guard let name =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        
        // 创建类名
        let cls : AnyObject? = NSClassFromString(name + "." + childControllerName)
        
        guard let typeCls = cls as? UITableViewController.Type else {
            return
        }
    
        let childController = typeCls.init()
        
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        // 包装导航控制器
        let nav = UINavigationController(rootViewController: childController)
        
        self.addChildViewController(nav)
    }

}
