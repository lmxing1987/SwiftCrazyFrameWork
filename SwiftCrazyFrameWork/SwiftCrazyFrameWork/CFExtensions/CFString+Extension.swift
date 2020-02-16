//
//  CFString+Extension.swift
//  SwiftCrazyFrameWork
//  String 扩展
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit
extension String {
    
    func cf_trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func cf_at(_ index: String.IndexDistance) -> String.Index {
        
        return self.index(self.startIndex, offsetBy: index)
    }
    
    /**
     根据时长格式化输出
     - parameter duration: 单位(秒)
     - returns: 返回格式化后的时长
     */
    func cf_getFormatterDuration(_ duration: Int) -> String {
        let hour = duration / 3600
        let minute = (duration - hour * 3600) / 60
        if hour <= 0 {
            return "\(minute)分钟"
        }
        if minute <= 0 {
            return "\(hour)小时"
        }
        return "\(hour)小时\(minute)分钟"
    }
    
    /// 获取本地化字符串
    /// - Returns: 本地化字符串
    func cf_localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    /// 获取字符串高度
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 宽度
    func cf_getHeigh(font: UIFont , width: CGFloat) -> CGFloat {
        let statusLabelText: String = self
        let size =  CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context:nil).size
        
        return strSize.height
    }
    
    /// 获取字符串宽度
    /// - Parameters:
    ///   - font: 字体
    ///   - height: 高度
    func cf_getWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: String = self
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context:nil).size
        
        return strSize.width
    }
    //使用正则表达式替换
    func cf_pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                               range: NSMakeRange(0, self.count),
                                               withTemplate: with)
        
    }
}
// 处理HTML
extension String {
    
    /// 去掉某个标签
    /// - Parameter tag: 标签名称
    func cf_deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    /// 去掉多个标签
    /// - Parameter tags: 标签数组
    func cf_deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.cf_deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
    
    ///去掉z所有标签
    mutating func cf_filterHTML() -> String?{
        let scanner = Scanner(string: self)
        var text: NSString?
        while !scanner.isAtEnd {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: &text)
            self = self.replacingOccurrences(of: "\(text == nil ? "" : text!)>", with: "")
        }
        // 去除调空格
        self = self.replacingOccurrences(of: "&nbsp;", with: "")
        return self
    }
}
// 编码转换
extension String {
    /// 获取String的md5字符串
    func cf_toMD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(hash)
    }
    
    /// base64编码
    func cf_toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    /// base64解码
    func cf_fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
// 转换
extension String {
    public var cf_bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return self.count > 0
        }
    }
    public var cf_int: Int? {
        return Int(self)
    }
    public var cf_int64: Int64? {
        return Int64(self)
    }
    public var cf_float: Float? {
        return Float(self)
    }
    public var cf_double: Double? {
        return Double(self)
    }
}
