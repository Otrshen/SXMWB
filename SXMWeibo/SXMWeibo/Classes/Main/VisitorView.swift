//
//  VisitorView.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/11.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var rotationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setupVisitorInfo(imageName: String? ,title: String) {
        titleLabel.text = title
        guard let name = imageName else {
            // 没有设置图标，是首页
            startAniamtion()
            return
        }
        
        rotationImageView.hidden = true
        // 不是首页
        iconImageView.image = UIImage(named: name)
    }
    
    private func startAniamtion() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        rotationImageView.layer.addAnimation(anim, forKey: nil)
    }
    
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil
            , options: nil).last as! VisitorView
    }
    
}
