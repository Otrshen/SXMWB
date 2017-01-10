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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        
        // 设置加号按钮的位置
        let rect = composeButton.frame
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
//        composeButton.frame = CGRectOffset(rect, 2 * width, 0)
    }
    
    func addChildViewControllers() {
        guard let filePath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else {
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath) else {
            return
        }
        
        /*
        Swift和OC不太一样, OC中一般情况如果发生错误会给传入的指针赋值, 而在Swift中使用的是异常处理机制
        1.以后但凡看大 throws的方法, 那么就必须进行 try处理, 而只要看到try, 就需要写上do catch
        2.do{}catch{}, 只有do中的代码发生了错误, 才会执行catch{}中的代码
        3. try  正常处理异常, 也就是通过do catch来处理
        try! 告诉系统一定不会有异常, 也就是说可以不通过 do catch来处理
        但是需要注意, 开发中不推荐这样写, 一旦发生异常程序就会崩溃
        如果没有异常那么会返回一个确定的值给我们
        
        try? 告诉系统可能有错也可能没错, 如果没有系统会自动将结果包装成一个可选类型给我们, 如果有错系统会返回nil, 如果使用try? 那么可以不通过do catch来处理
        */
        do {
            let objc = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [[String : AnyObject]]
            
            for dict in objc {
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(vcName, title: title, imageName: imageName)
            }
        } catch {
            // 只要try对应的方法发生了异常, 就会执行catch{}中的代码
            addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController("NullViewController", title: "", imageName: "")
            addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }

    }
    
    func addChildViewController(childControllerName: String?, title : String?, imageName : String?) {
        
        // 动态获取命名空间
        guard let name =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        
        // 创建类名
        var cls : AnyObject? = nil
        if let vcName = childControllerName {
            cls = NSClassFromString(name + "." + vcName)
        }
        
        guard let typeCls = cls as? UITableViewController.Type else {
            return
        }
    
        let childController = typeCls.init()
        
        childController.title = title
        
        if let ivName = imageName {
            childController.tabBarItem.image = UIImage(named: ivName)
            childController.tabBarItem.selectedImage = UIImage(named: ivName + "_highlighted")
        }
        
        // 包装导航控制器
        let nav = UINavigationController(rootViewController: childController)
        
        self.addChildViewController(nav)
    }

    // MARK: - 懒加载
    lazy var composeButton : UIButton = {
        () -> UIButton in
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: Selector("composeBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    @objc private func composeBtnClick() {
        SXMLog("a")
    }
    
}
