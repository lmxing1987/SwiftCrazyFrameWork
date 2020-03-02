//
//  CFCacheUtils.swift
//  SwiftCrazyFrameWork
//  缓存工具类(内存，磁盘 key-value)
//  Created by mxlai on 2020/2/24.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import YYCache
public enum CFCacheState {
    case  CFCacheAll
    case  CFCacheMemory
    case  CFCacheDisk
}
open class CFCacheUtils {
    static var cacheDbName = "YYCacheDB"
    let cache : YYCache? = YYCache.init(name: CFCacheUtils.cacheDbName) ?? nil
    
    /// 判断key是否存在
    /// - Parameter key: key
    open func cf_containsObjectForKey(_ key: String) -> Bool {
        return  cache?.containsObject(forKey: key) ?? false
    }
    
    /// 判断key是否存在指定位置
    /// - Parameters:
    ///   - key: key
    ///   - cacheState: 缓存位置状态
    open func cf_containsObjectForKey(_ key: String,_ cacheState: CFCacheState) -> Bool {
        var isContains = false
        switch cacheState {
        case .CFCacheMemory:
            isContains = cache?.memoryCache.containsObject(forKey: key) ?? false
        case .CFCacheDisk:
            isContains = cache?.diskCache.containsObject(forKey: key) ?? false
        default:
            isContains = cache?.containsObject(forKey: key) ?? false
        }
        return isContains
    }
    
    /// 获取值
    /// - Parameter key: key
    open func cf_objectForKey(_ key: String) -> Optional<Any> {
        return cache?.object(forKey: key)
    }
    
    /// 获取值
    /// - Parameters:
    ///   - key: key
    ///   - cacheState: 缓存位置
    open func cf_objectForKey(_ key: String,_ cacheState: CFCacheState) -> Optional<Any> {
        var obj:Optional<Any> = nil
        switch (cacheState) {
        case .CFCacheMemory:
            obj = cache?.memoryCache.object(forKey: key)
            break;
        case .CFCacheDisk:
            obj = cache?.diskCache.object(forKey: key)
            break;
        default:
            obj=cache?.object(forKey: key)
            break;
        }
        return obj;
    }
    
    /// 缓存数据
    /// - Parameters:
    ///   - object: value 遵循 NSCoding
    ///   - forKey: key
    open func cf_setObject(_ object: NSCoding,_ forKey: String) {
        cache?.setObject(object, forKey: forKey)
    }
    
    
    /// 缓存数据
    /// - Parameters:
    ///   - object: value 遵循 NSCoding
    ///   - forKey: key
    ///   - cacheState: 缓存位置
    open func cf_setObject(_ object: NSCoding,_ forKey: String,_ cacheState: CFCacheState) {
        switch (cacheState) {
        case .CFCacheMemory:
            cache?.memoryCache.setObject(object, forKey: forKey)
            break;
        case .CFCacheDisk:
            cache?.diskCache.setObject(object, forKey: forKey)
            break;
        default:
            cache?.setObject(object, forKey: forKey)
            break;
        }
    }
    
    
    /// 带缓存过期时间的设置
    /// - Parameters:
    ///   - object: value
    ///   - forKey: key
    ///   - cacheTime: 缓存时间
    open func cf_setObject(_ object: NSCoding,_ forKey: String,_ cacheTime: Int) {
        let currentTime = Date.cf_getCurrentTimeStamp()
        let expireTime = currentTime + cacheTime
        let dic:NSDictionary = ["objectValue" : object, "expireTime" : expireTime] as NSDictionary
        cache?.setObject(dic, forKey: forKey)
    }
    
    
    /// 获取带时间缓存对象
    /// - Parameter key: key
    open func cf_objectHavaExpireTimeForKey(_ key: String) -> Optional<Any> {
        var oldObj:Optional<Any> = nil
        if self.cf_containsObjectForKey(key) {
            oldObj=self.cf_objectForKey(key, .CFCacheDisk);
        }
        if oldObj != nil {
            if (oldObj.self is NSDictionary) {
                let dataDic = oldObj as! Dictionary<String, Any>
                let expireTime = dataDic .cf_getIntValueForKey("expireTime", 0)
                let currentTime = Date.cf_getCurrentTimeStamp()
                
                if expireTime > currentTime {
                    let obj = dataDic["objectValue"];
                    return obj;
                }else{
                    self.cf_removeObjectForKey(key);
                }
            }
        }
        return nil;
    }
    
    
    /// 分组设置数据,区分内存还是磁盘
    /// - Parameters:
    ///   - object: 对象
    ///   - forKey: key
    ///   - groupKey: groupKey
    ///   - cacheState: cacheState
    open func cf_setObject(_ object: NSCoding,_ forKey: String, groupKey: String, cacheState: CFCacheState) {
        if object == nil || forKey.count == 0 {
            return ;
        }
        var oldObj = NSMutableDictionary()
        if self.cf_containsObjectForKey(groupKey, cacheState) {
            let  oldTempObj = self.cf_objectForKey(groupKey, cacheState);
            oldObj = NSMutableDictionary(sharedKeySet: oldTempObj as Any)
        }
        oldObj.setObject(object, forKey: forKey as NSString)
        self.cf_setObject(oldObj, groupKey)
    }
    
    open func cf_objectForKey(_ key: String,_ groupKey: String,_ cacheState: CFCacheState) -> Optional<Any> {
        if self.cf_containsObjectForKey(groupKey,cacheState) {
            let oldTempObj = self.cf_objectForKey(groupKey,cacheState);
            
            let oldObj = NSMutableDictionary(sharedKeySet: oldTempObj as Any)
            
            let value = oldObj.object(forKey: key)
            return value;
        }
        return nil;
    }
    
    
    /// 分组判断是否存在，区分内存还是磁盘
    /// - Parameters:
    ///   - key: key
    ///   - groupKey: groupKey
    ///   - cacheState: cacheState
    open func cf_containsObjectForKey(_ key: String,_ groupKey: String,_ cacheState: CFCacheState) -> Bool {
        
        if self.cf_containsObjectForKey(groupKey, cacheState) {
            let oldTempObj = self.cf_objectForKey(groupKey, cacheState)
            let oldObj = NSMutableDictionary(sharedKeySet: oldTempObj as Any)
            let value=oldObj.object(forKey: key)
            if (value != nil) {
                return true;
            }
        }
        return false;
    }
    
    /// 移除lkey
    /// - Parameters:
    ///   - key: key
    ///   - groupKey: groupKey
    ///   - cacheState: cacheState
    open func cf_removeObjectForKey(_ key: String,_ groupKey: String,_ cacheState: CFCacheState) {
        
        if self.cf_containsObjectForKey(groupKey,cacheState) {
            let oldTempObj = self.cf_objectForKey(groupKey,cacheState)
            let oldObj = NSMutableDictionary(sharedKeySet: oldTempObj)
            oldObj.removeObject(forKey: key)
            self.cf_setObject(oldObj,groupKey,cacheState)
        }
    }
    
    
    /// 移除key
    /// - Parameter key: key
    open func cf_removeObjectForKey(_ key: String) {
        cache?.removeObject(forKey: key)
    }
    
    /// 移除所有缓存
    open func cf_removeAllObjects() {
        cache?.removeAllObjects()
    }
    
}
