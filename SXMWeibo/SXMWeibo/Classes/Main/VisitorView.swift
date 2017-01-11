//
//  VisitorView.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/11.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil
            , options: nil).last as! VisitorView
    }

}
