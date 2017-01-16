//
//  HomeTableViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回到这里看看有什么惊喜")
            return
        }
        
        setupNav()
    }
    
    // MARK: - 内部控制方法
    private func setupNav()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: Selector("leftBtnClick"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: Selector("rightBtnClick"))
        
        // 2.添加标题按钮
        let titleButton = TitleButton()
        titleButton.setTitle("LarkNan", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
    }
    
    @objc private func titleBtnClick(btn: TitleButton) {
        // 修改状态
        btn.selected = !btn.selected
        
        // 显示菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        
        // 设置转场代理
        menuView.transitioningDelegate = self
        // 设置转场动画
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    @objc private func leftBtnClick() {
        SXMLog("")
    }
    
    @objc private func rightBtnClick() {
        SXMLog("")
    }
}

extension HomeTableViewController:UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return SXMPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // 该方法用于放回一个负责转场如何出现的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // 如何消失
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension HomeTableViewController: UIViewControllerAnimatedTransitioning {
    // 告诉系统展现和消失的动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 3
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
        NJLog(toVC)
        NJLog(fromVC)
        */
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
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
    }
}
