//
//  HomeTableViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeTableViewController: BaseTableViewController {

    // 保存所有微博数据
    var statuses: [StatusViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回到这里看看有什么惊喜")
            return
        }
        
        setupNav()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: SXMPresentationManagerDidPresented, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleChange"), name: SXMPresentationManagerDidDismissed, object: animatorManager)
        
        // 获取微博数据
        loadData()
        
        // 设置tableView
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = SXMRefreshControl()
        refreshControl?.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshing()
        
        // 提示框
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
    }
    
    // MARK: - 内部控制方法
    @objc private func loadData() {
        
        let since_id = statuses?.first?.status.idstr ?? "0"
        
        NetworkTools.shareInstance.loadStatuses(since_id) { (array, error) -> () in
            if error != nil {
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
                SVProgressHUD.showErrorWithStatus("获取微博数据失败")
                return
            }
            
            guard let arr = array else {
                return
            }
            
            // 将字典数组转换为模型数组
            var models = [StatusViewModel]()
            for dict in arr {
                let status = StatusViewModel(status: Status(dict: dict))
                models.append(status)
            }
            
            // 处理微博数据
            if since_id != "0" {
                self.statuses = models + self.statuses!
            } else {
                self.statuses = models
            }
            
            // 缓存微博所有配图
            self.cachesImages(models)
            
            self.refreshControl?.endRefreshing()
            
            // 显示刷新提醒
            self.showRefreshStatus(models.count)
        }
    }
    
    private func showRefreshStatus(count: Int) {
        tipLabel.text = (count == 0) ? "没有更多数据" : "刷新到\(count)条数据"
        tipLabel.hidden = false
        // 执行动画
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44)
            }) { (_) -> Void in
                UIView.animateKeyframesWithDuration(1.0, delay: 2.0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.tipLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.tipLabel.hidden = true
                })
        }
    }
    
    private func cachesImages(viewModels: [StatusViewModel]) {
        // 创建一个组
        let group = dispatch_group_create()
        
        for viewModel in viewModels {
            guard let picurls = viewModel.thumbnail_pic else {
                continue
            }
            
            // 遍历配图数组下载图片
            for url in picurls {
                // 将下载操作添加到组中
                dispatch_group_enter(group)
                // 下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) -> Void in
                    SXMLog("图片下载完成")
                    // 将当前下载操作从组中移除
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            SXMLog("全部图片下载完成");
            self.tableView.reloadData()
        }
    }
    
    private func setupNav() {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: Selector("leftBtnClick"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: Selector("rightBtnClick"))
        
        // 2.添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    @objc private func leftBtnClick() {
        SXMLog("")
    }
    
    // 二维码
    @objc private func rightBtnClick() {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @objc private func titleChange () {
        titleButton.selected = !titleButton.selected
    }
    
    @objc private func titleBtnClick(btn: TitleButton) {
        // 显示菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        
        // 设置转场代理
        menuView.transitioningDelegate = animatorManager
        // 设置转场动画
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - lazy
    private lazy var animatorManager: SXMPresentationManager = {
        let manager = SXMPresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 400)
        return manager
    }()
    
    private lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    // 缓存行高
    private var rowHeightCaches = [String: CGFloat]()
    
    // 刷新提示视图
    private var tipLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.orangeColor()
        lb.text = "没有更多数据"
        lb.textAlignment = NSTextAlignment.Center
        lb.textColor = UIColor.whiteColor()
        let width = UIScreen.mainScreen().bounds.width
        lb.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        lb.hidden = true
        return lb
    }()
}

extension HomeTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let viewModel = statuses![indexPath.row]
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! HomeTableViewCell
        cell.viewModel = viewModel
        
        return cell
    }
    
    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 从缓存中获取行高
        let viewModel = statuses![indexPath.row]
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"] else {
            SXMLog("计算行高\(indexPath.row))")
            // 缓存中有行高
            // 获取当前行对应的cell
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! HomeTableViewCell
            let temp = cell.calcuateRowHeight(viewModel)
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            return temp
        }

        // 缓存中有直接返回
        return height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放缓存
        rowHeightCaches.removeAll()
    }
}
