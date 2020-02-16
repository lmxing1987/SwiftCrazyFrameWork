//  全局需要用到的常量
//  CFACMacros.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/10.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit
// 沙盒路径
public let kPATH_OF_APP_HOME = NSHomeDirectory()
public let kPATH_OF_TEMP = NSTemporaryDirectory()
public let kPATH_OF_DOCUMENT = FileManager.SearchPathDirectory.documentDirectory
public let kPATH_OF_CACHES = FileManager.SearchPathDirectory.cachesDirectory

// 设备相关
public let kUniqueString = ProcessInfo.processInfo.globallyUniqueString

public let kIsIphoneX: Bool = {
    var isphoneX = false
    if #available(iOS 11.0, *), let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets , safeAreaInsets.bottom > 0 {
        isphoneX = true
    }
    return isphoneX
}()
public let kIsPad = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
//时间相关
/** 时间间隔 */
public let kHUDDuration = 1
/** 一天的秒数 */
public let kSecondsOfDay = (24 * 60 * 60)
/** 秒数 */
public func Seconds(_ days: Int) -> Int { return (kSecondsOfDay * days) }
/** 一天的毫秒数 */
public let kMillisecondsOfDay = (24 * 60 * 60 * 1000)
/** 毫秒数 */
public func Milliseconds(_ days: Int) -> Int { return kMillisecondsOfDay * (days) }

// 输出日志
public func CFLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("CFLog:\(fileName):(\(lineNum))-\(messsage)\n")
    #endif
}
