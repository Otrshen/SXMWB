//
//  NSDate+Extension.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

extension NSDate {
    /**
     根据一个字符串创建一个NSDate
     */
    class func createDate(timeStr: String, formatterStr: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterStr
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.dateFromString(timeStr)!
    }
    
    /**
     生成当前时间对应的字符串
     */
    func descriptionStr() -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        // 日历类
        let calendar = NSCalendar.currentCalendar()
        // 时间格式
        var formatterStr = "HH:mm"
        
        if calendar.isDateInToday(self) { // 今天
            let interval = Int(NSDate().timeIntervalSinceDate(self))
            
            if interval < 60 {
                return "刚刚"
            } else if interval < 60 * 60 {
                return "\(interval / 60)分钟前"
            } else if interval < 60 * 60 * 24 {
                return "\(interval / (60 * 60))小时前"
            }
        } else if calendar.isDateInYesterday(self) { // 昨天
            formatterStr = "昨天 " + formatterStr
        } else {
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if comps.year >= 1 { // 更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
            } else { // 一年以内
                formatterStr = "MM-dd " + formatterStr
            }
            
        }
        
        formatter.dateFormat = formatterStr
        return formatter.stringFromDate(self)
    }
}