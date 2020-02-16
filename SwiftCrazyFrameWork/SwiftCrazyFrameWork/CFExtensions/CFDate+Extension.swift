//
//  CFDate+Extension.swift
//  SwiftCrazyFrameWork
//  Date 扩展
//  Created by mxlai on 2020/2/13.
//  Copyright © 2020 mxlai. All rights reserved.
//

extension Date {
 
    /// 获取当前 秒级 时间戳 - 10位
    static func cf_getCurrentTimeStamp() -> Int {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    static func cf_getCurrentTimeMilliStamp() -> Int64 {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond;
    }
    
    /// 获取当前日期
    /// - Parameter format: 日期格式
    static func cf_currentDate(format: String) -> String {
        let currentdate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let customDate = dateformatter.string(from: currentdate)
        return customDate
    }
    /// 获取农历日期
    /// - Parameter type: type 显示类型，默认 年月日 1 只显示年月
    func cf_getChineseCalendar(_ type: Int) -> String {
        
        let chineseYears = ["甲子", "乙丑", "丙寅", "丁卯",  "戊辰",  "己巳",  "庚午",  "辛未",  "壬申",  "癸酉",
                            "甲戌", "乙亥", "丙子", "丁丑", "戊寅",  "己卯",  "庚辰",  "辛己",  "壬午",  "癸未",
                            "甲申",  "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳",
                            "甲午",  "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸丑",
                            "甲辰",  "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑",
                            "甲寅",  "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]
        let chineseMonths = ["正月","二月","三月","四月","五月","六月","七月","八月",
                             "九月","十月","冬月","腊月"]
        let chineseDays = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
                           "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
                           "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]
        let localeCalendar = Calendar.init(identifier: Calendar.Identifier.chinese)
        let localeComp = localeCalendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: self)
        
        let y_str = chineseYears[localeComp.year! - 1]
        let m_str = chineseMonths[localeComp.month! - 1]
        let d_str = chineseDays[localeComp.day! - 1]
        var chineseCal_str = "\(y_str) \(m_str)\(d_str)"
        if (type==1) { //只显示月日
            chineseCal_str = "\(m_str)\(d_str)"
        }
        return chineseCal_str
    }
}
