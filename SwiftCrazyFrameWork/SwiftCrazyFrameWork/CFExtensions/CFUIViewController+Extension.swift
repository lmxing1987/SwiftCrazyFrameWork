//
//  CFUIViewController+Extension.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//
import UIKit

extension UIViewController {
    /// 返回
    ///
    /// - Parameter animated: 是否做动画
    func cf_backToViewController(animated: Bool) {
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.count == 1 {
                self.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
            
        } else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    // MARK: - 跳转相关
    /// 快速push到指定控制器 name:控制器名
    func cf_pushController(name:String) {
        _ = cf_pushSetController(name: name)
    }
    
    func cf_pushSetController(name:String) -> UIViewController {
        weak var weakSelf = self // 弱引用
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return UIViewController()
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            return UIViewController()
        }
        // 3.通过Class创建对象
        let vc = clsType.init()
        weakSelf!.navigationController?.pushViewController(vc, animated: true)
        return vc
    }
    
    /// 快速返回指定的控制器 name:要返回的控制器名 (注意:要返回的控制器必须在navigationController的子控制器数组中)
    func cf_popToViewController(name:String) { // 使用 self.popToViewController(name: "JYKMeViewController")
        weak var weakSelf = self // 弱引用
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard (cls as? UIViewController.Type) != nil else {
            return
        }
        for  controller in (weakSelf!.navigationController?.viewControllers)! {
            if controller.isKind(of: cls!) {
                weakSelf!.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    /// 快速返回根的控制器
    func cf_popToRootViewController() {
        weak var weakSelf = self // 弱引用
        weakSelf!.navigationController?.popToRootViewController(animated: true)
    }
    
    func cf_presentController(name:String) {
        _ = cf_presentSetController(name: name)
    }
    func cf_presentSetController(name:String) -> UIViewController {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return UIViewController()
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + name)
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            return UIViewController()
        }
        // 3.通过Class创建对象
        let vc = clsType.init()
        let nav = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: {
        })
        return vc
    }
    
    /// 当前的控制器
    ///
    /// - Returns: 控制器
    class func cf_currentViewController() -> UIViewController {
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            return self.cf_currentViewController(form: rootVC)
        } else {
            return UIViewController()
        }
    }
    
    /// 根据根控制器的类型返回当前的控制器
    ///
    /// - Parameter fromVC: 根控制器
    /// - Returns: 返回的控制器
    class func cf_currentViewController(form fromVC: UIViewController) -> UIViewController {
        if fromVC.isKind(of: UINavigationController.self) {
            let navigationController = fromVC as! UINavigationController
            return cf_currentViewController(form: navigationController.viewControllers.last!)
        }
        else if fromVC.isKind(of: UITabBarController.self) {
            let tabBarController = fromVC as! UITabBarController
            return cf_currentViewController(form: tabBarController.selectedViewController!)
        }
        else if fromVC.presentedViewController != nil {
            return cf_currentViewController(form: fromVC.presentingViewController!)
        }
        else {
            return fromVC
        }
    }
}
