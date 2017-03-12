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

    @IBOutlet weak var pictureCollectionView: SXMPictureView!
    @IBOutlet weak var iconImageView: UIImageView!
    // 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    // 正文
    @IBOutlet weak var contentLabel: UILabel!
    // 底部视图
    @IBOutlet weak var footerView: UIView!
    // 转发微博正文
    @IBOutlet weak var forwardLabel: UILabel!
    
    var viewModel: StatusViewModel? {
        didSet{
            // 设置头像
            iconImageView.sd_setImageWithURL(viewModel?.icon_URL)
            
            // 认证图标
            verifiedImageView.image = viewModel?.verified_image
            
            // 会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.blackColor()
            if let image = viewModel?.mbrankImage {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orangeColor()
            }
            
            // 昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            timeLabel.text = viewModel?.created_Time
          
            // 来源
            sourceLabel.text = viewModel?.source_Text
            
            contentLabel.text = viewModel?.status.text
            
            // 设置配图
            pictureCollectionView.viewModel = viewModel
                       
            // 转发微博
            if let text = viewModel?.forwardText {
                forwardLabel.text = text
                forwardLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10
        iconImageView.layer.cornerRadius = 30
    }
    
    // MARK: - 外部控制方法
    func calcuateRowHeight(viewModel: StatusViewModel) -> CGFloat {
        self.viewModel = viewModel
        self.layoutIfNeeded() // 更新UI
        return CGRectGetMaxY(footerView.frame)
    }
}
