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
            
            // 会员图标
            if let rank = status?.user?.mbrank {
                if rank >= 1 && rank <= 6 {
                    vipImageView.image = UIImage(named: "common_icon_membership_level\(rank)")
                    nameLabel.textColor = UIColor.orangeColor()
                } else {
                    vipImageView.image = nil
                    nameLabel.textColor = UIColor.blackColor()
                }
            }
            
            nameLabel.text = status?.user?.screen_name
            
            /**
            刚刚(一分钟内)
            X分钟前(一小时内)
            X小时前(当天)
            
            昨天 HH:mm(昨天)
            
            MM-dd HH:mm(一年内)
            yyyy-MM-dd HH:mm(更早期)
            */
            if var timeStr = status?.created_at {
                timeStr = "Sun Dec 05 12:10:41 +0800 2017"
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EE MM dd HH:mm:ss Z yyyy"
                formatter.locale = NSLocale(localeIdentifier: "en")
                let createDate = formatter.dateFromString(timeStr)!
                
                // 日历类
                let calendar = NSCalendar.currentCalendar()

                var result = ""
                var formatterStr = "HH:mm"
                
                if calendar.isDateInToday(createDate) { // 今天
                    let interval = Int(NSDate().timeIntervalSinceDate(createDate))
                    
                    if interval < 60 {
                        result = "刚刚"
                    } else if interval < 60 * 60 {
                        result = "\(interval / 60)分钟前"
                    } else if interval < 60 * 60 * 24 {
                        result = "\(interval / (60 * 60))小时前"
                    }
                } else if calendar.isDateInYesterday(createDate) { // 昨天
                    formatterStr = "昨天 " + formatterStr
                    formatter.dateFormat = formatterStr
                    result = formatter.stringFromDate(createDate)
                } else {
                    let comps = calendar.components(NSCalendarUnit.Year, fromDate: createDate, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
                    if comps.year >= 1 { // 更早时间
                        formatterStr = "yyyy-MM-dd " + formatterStr
                    } else { // 一年以内
                        formatterStr = "MM-dd " + formatterStr
                    }
                    formatter.dateFormat = formatterStr
                    result = formatter.stringFromDate(createDate)
                }
                
                timeLabel.text = result
            }
            
            // 来源
            if let sourceStr: NSString = status?.source where sourceStr != "" {
                let startIndex = sourceStr.rangeOfString(">").location + 1
                let length = sourceStr.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
                let rest = sourceStr.substringWithRange(NSMakeRange(startIndex, length))
                sourceLabel.text = "来自: " + rest
            }
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
