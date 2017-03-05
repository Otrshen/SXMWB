//
//  RefreshView.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/3/5.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SnapKit

class SXMRefreshControl: UIRefreshControl {
    override init() {
        super.init()
        // 添加子控件
        addSubview(refreshView)
        // 布局控件
        refreshView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 150, height: 50))
            let marginLR: CGFloat = (UIScreen.mainScreen().bounds.size.width - 150) / 2
            make.edges.equalTo(UIEdgeInsets(top: 0, left: marginLR, bottom: 0, right: marginLR))
//            make.center.equalTo(self)
        }
        
        // 监听SXMRefreshControl frame的改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingView()
    }
    
    // 记录是否需要旋转
    var rotationFlag = false
    
    // MRAK: - 内部控制方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y == 0 || frame.origin.y == -64 { return }
        
        // 是否触发了下拉刷新事件
        if refreshing {
            // 隐藏箭头视图，显示旋转视图
            refreshView.startLoadingView()
            return
        }
        
        if frame.origin.y < -50 && !rotationFlag {
            SXMLog("上")
            rotationFlag = true
            refreshView.rotationArrow(rotationFlag)
        } else if frame.origin.y > -50 && rotationFlag {
            SXMLog("下")
            rotationFlag = false
            refreshView.rotationArrow(rotationFlag)
        }
    }
    
    // MRAK: - lazy
    private lazy var refreshView: RefreshView = RefreshView.refreshView()
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
}

class RefreshView: UIView {

    // 菊花
    @IBOutlet weak var loadingImageView: UIImageView!
    // 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    // 提示
    @IBOutlet weak var tipView: UIView!
    
    class func refreshView() -> RefreshView {
        return NSBundle.mainBundle().loadNibNamed("RefreshView", owner: nil
            , options: nil).last as! RefreshView
    }
    
    // MRAK: - 外部控制方法
    // 旋转箭头
    func rotationArrow(flag: Bool) {
        var angle: CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(M_PI)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle)
        }
    }
    
    // 显示提示视图
    func startLoadingView() {
        // 隐藏提示视图
        tipView.hidden = true
        
        if let _ = loadingImageView.layer.animationForKey("sxm") {
            return
        }
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 1.0
        anim.repeatCount = MAXFLOAT

        loadingImageView.layer.addAnimation(anim, forKey: "sxm")
    }
    
    func stopLoadingView() {
        // 显示提示视图
        tipView.hidden = false
        
        loadingImageView.layer.removeAllAnimations()
    }
}
