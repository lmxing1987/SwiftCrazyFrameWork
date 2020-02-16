//
//  CFAppUtils.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/15.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit

public class CFAppUtils {
    static public let infoDictionary = Bundle.main.infoDictionary
    //App 名称
    static public let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    // Bundle Identifier
    static public let bundleIdentifier:String = Bundle.main.bundleIdentifier!
    // App 版本号
    static public let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String
    //Bulid 版本号
    static public let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String
    //ios 版本
    static public let iOSVersion: String = UIDevice.current.systemVersion
    //设备 udid
    static public let identifierNumber = UIDevice.current.identifierForVendor!.uuidString
    //设备名称
    static public let systemName = UIDevice.current.systemName
    // 设备型号
    static public let model = UIDevice.current.model
    //设备区域化型号
    static public let localizedModel = UIDevice.current.localizedModel
    //当前的视图
    static public var currentViewController: UIViewController? {
        var resultVC: UIViewController?
        resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
        while resultVC?.presentedViewController != nil {
            resultVC = _topVC(resultVC?.presentedViewController)
        }
        return resultVC
    }

    private static func _topVC(_ vc: UIViewController?) -> UIViewController? {
        if vc is UINavigationController {
            return _topVC((vc as? UINavigationController)?.topViewController)
        } else if vc is UITabBarController {
            return _topVC((vc as? UITabBarController)?.selectedViewController)
        } else {
            return vc
        }
    }
}
