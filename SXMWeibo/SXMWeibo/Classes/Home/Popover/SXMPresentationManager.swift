//
//  SXMPresentationManager.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/17.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class SXMPresentationManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    private var isPresent = false
    // 菜单尺寸
    var presentFrame = CGRectZero
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    // 该方法用于返回一个负责转场动画的对象
    // 可以在该对象中控制弹出视图的尺寸等
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = SXMPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    // 该方法用于返回一个负责转场如何出现的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        NSNotificationCenter.defaultCenter().postNotificationName(SXMPresentationManagerDidPresented, object: self)
        return self
    }
    
    // 如何消失
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(SXMPresentationManagerDidDismissed, object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    // 告诉系统展现和消失的动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // 专门用于管理modal如何展现和消失的, 无论是展现还是消失都会调用该方法
    /*
    注意点: 只要我们实现了这个代理方法, 那么系统就不会再有默认的动画了
    也就是说默认的modal从下至上的移动系统不帮再帮我们添加了, 所有的动画操作都需要我们自己实现, 包括需要展现的视图也需要我们自己添加到容器视图上(containerView)
    */
    // transitionContext: 所有动画需要的东西都保存在上下文中, 换而言之就是可以通过transitionContext获取到我们想要的东西
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取需要弹出视图
        /*
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        */
        if isPresent { // 展现
            willPresentedController(transitionContext)
        } else {
            willDismissedController(transitionContext)
        }
    }
    
    /// 执行展现动画
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning) {
        // 通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else
        {
            return
        }
        
        // 2.将需要弹出的视图添加到containerView上
        transitionContext.containerView()?.addSubview(toView)
        
        // 执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        // 设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    /// 执行消失动画
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else
        {
            return
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.0001)
            }, completion: { (_) -> Void in
                transitionContext.completeTransition(true)
        })
    }
    
}