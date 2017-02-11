//
//  WelcomeViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/7.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // 头像底部约束
    @IBOutlet weak var iconButtomCons: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置头像圆角
        iconImageView.layer.cornerRadius = 45
        iconImageView.layer.masksToBounds = true
        
        assert(UserAccount.loadUserAccount()!.avatar_large != nil, "需授权")
        guard let url = NSURL(string: UserAccount.loadUserAccount()!.avatar_large!) else {
            return
        }
        iconImageView.sd_setImageWithURL(url)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        iconButtomCons.constant = (UIScreen.mainScreen().bounds.height - iconButtomCons.constant)
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    self.titleLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        /*
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
                        */
                    NSNotificationCenter.defaultCenter().postNotificationName(SXMSwichRootViewController, object: true)
                })
        }
    }
}
