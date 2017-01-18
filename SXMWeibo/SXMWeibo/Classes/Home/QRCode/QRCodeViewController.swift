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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabbar.selectedItem = customTabbar.items?.first
    }
    

    @IBAction func photoBtnClick(sender: AnyObject) {
    }

    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true , completion: nil)
    }
}
