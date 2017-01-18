//
//  QRCodeViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/18.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBOutlet weak var customTabbar: UITabBar!
    // 容器视图的高度约束
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    // 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    // 冲击波顶部约束
    @IBOutlet weak var scanLineConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabbar.selectedItem = customTabbar.items?.first
        
        // 监听底部工具条的点击
        customTabbar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    // 开启冲击波动画
    private func startAnimation() {
        scanLineConstraint.constant = -containerHeightConstraint.constant
        view.layoutIfNeeded()
        
        // 执行扫描动画
        UIView.animateWithDuration(2.0) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineConstraint.constant = self.containerHeightConstraint.constant
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func photoBtnClick(sender: AnyObject) {
    }

    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true , completion: nil)
    }
}

extension QRCodeViewController: UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        SXMLog(item.tag)
        
        containerHeightConstraint.constant = item.tag == 1 ? 150 : 300
        view.layoutIfNeeded()
        
        // 移除动画
        scanLineView.layer.removeAllAnimations()
        
        startAnimation()
    }
}
