//
//  StatusListModel.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/3/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SDWebImage

class StatusListModel: NSObject {

    // 保存所有微博数据
    var statuses: [StatusViewModel]?
    
    func loadData(lastStatus : Bool, finished: (models: [StatusViewModel]?, error: NSError?) -> ()) {
        
        var since_id = statuses?.first?.status.idstr ?? "0"
        var max_id = "0"
        if lastStatus {
            since_id = "0"
            max_id = statuses?.last?.status.idstr ?? "0"
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (array, error) -> () in
            if error != nil {
                finished(models: nil, error: error)
                return
            }
            
            // 将字典数组转换为模型数组
            var models = [StatusViewModel]()
            for dict in array! {
                let status = StatusViewModel(status: Status(dict: dict))
                models.append(status)
            }
            
            // 处理微博数据
            if since_id != "0" {
                self.statuses = models + self.statuses!
            } else if max_id != "0" {
                self.statuses = self.statuses! + models
            } else {
                self.statuses = models
            }
            
            // 缓存微博所有配图
            self.cachesImages(models, finished: finished)
            
//            self.refreshControl?.endRefreshing()
//            
//            // 显示刷新提醒
//            self.showRefreshStatus(models.count)
        }
    }
    
    private func cachesImages(viewModels: [StatusViewModel],  finished: (models: [StatusViewModel]?, error: NSError?) -> ()) {
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
            finished(models: viewModels, error: nil)
        }
    }
}
