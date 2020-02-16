//
//  CFDictionary+Extension.swift
//  SwiftCrazyFrameWork
//  Dictionary 扩展
//  Created by mxlai on 2020/2/15.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 获取字典里的Bool值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func cf_getBoolValueForKey(_ key: String,_ defaultValue: Bool) -> Bool {
        return cf_getValueForKey(key, defaultValue, Bool.self)
    }
    
    /// 获取字典里的Int值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func cf_getIntValueForKey(_ key: String,_ defaultValue: Int) -> Int {
       return cf_getValueForKey(key, defaultValue, Int.self)
    }
    /// 获取字典里的Int64值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func cf_getInt64ValueForKey(_ key: String,_ defaultValue: Int64) -> Int64 {
       return cf_getValueForKey(key, defaultValue, Int64.self)
    }
    /// 获取字典里的String值
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    public func cf_getStringValueForKey(_ key: String,_ defaultValue: String) -> String {
        return cf_getValueForKey(key, defaultValue, String.self)
    }
    
    /// 获取字典里的值 自定义类型
    /// - Parameters:
    ///   - key: key
    ///   - defaultValue: 默认值
    ///   - valueType: 值类型 String.self
    public func cf_getValueForKey<T>(_ key: String,_ defaultValue: T,_ valueType: T.Type) -> T {
        guard let dict:Dictionary<String,AnyObject> = self as? Dictionary<String,AnyObject> else {
            return defaultValue
        }
        guard let value = dict[key] as? T else {
            let value = "\(dict[key]!)"
            if valueType == Int.self {
                return value.cf_int as! T
            } else if valueType == Int64.self {
                return value.cf_int64 as! T
            } else if valueType == Double.self {
                return value.cf_double as! T
            } else if valueType == Float.self {
                return value.cf_float as! T
            } else if valueType == Bool.self {
                return value.cf_bool as! T
            } else if valueType == String.self {
                return value as! T
            } else {
                return defaultValue
            }
        }
        return value
    }
}
