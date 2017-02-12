//
//  HomeTableViewCell.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    // 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    // 正文
    @IBOutlet weak var contentLabel: UILabel!
    
    var status: Status? {
        didSet{
            // 设置头像
            if let urlStr = status?.user?.profile_image_url {
                let url = NSURL(string: urlStr)
                iconImageView.sd_setImageWithURL(url)
            }
            
            // 认证图标
            if let type = status?.user?.verified_type {
                var name = ""
                switch type {
                case 0:
                    name = "avatar_vip"
                case 2, 3, 5:
                    name = "avatar_enterprise_vip"
                case 220:
                    name = "avatar_grassroot"
                default:
                    name = ""
                }
                
                verifiedImageView.image = UIImage(named: name)
            }
            
            
            nameLabel.text = status?.user?.screen_name
            timeLabel.text = status?.created_at
            sourceLabel.text = status?.source
            contentLabel.text = status?.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10
        iconImageView.layer.cornerRadius = 30
    }

}
