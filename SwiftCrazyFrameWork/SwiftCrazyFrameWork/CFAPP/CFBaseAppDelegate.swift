//
//  CFBaseAppDelegate.swift
//  SwiftCrazyFrameWork
//  AppDelegate 基类可继承使用
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//
import UIKit
import Alamofire
import IQKeyboardManagerSwift

public class CFBaseAppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    
    lazy var reachability: NetworkReachabilityManager? = {
       return NetworkReachabilityManager(host: "http://www.baidu.com")
    }()
    
    var orientation: UIInterfaceOrientationMask = .portrait

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           // Override point for customization after application launch.
           cf_baseConfig()
           print("Hello world")
           return true
       }

    func cf_baseConfig() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        reachability?.listener = { status in
            switch status {
            case .reachable(.wwan):
                CFNoticeBarView(config: CFNoticeBarConfig(title: "主人,检测到您正在使用移动数据")).show(duration: 2)
            default: break
            }
        }
        reachability?.startListening()
    }
    
    // 屏幕旋转的转态返回
    public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication {
    class func cf_changeOrientationTo(landscapeRight: Bool) {
        guard let delegate = UIApplication.shared.delegate as? CFBaseAppDelegate else { return }
        if landscapeRight == true {
            // 横屏
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            // 竖屏
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}

