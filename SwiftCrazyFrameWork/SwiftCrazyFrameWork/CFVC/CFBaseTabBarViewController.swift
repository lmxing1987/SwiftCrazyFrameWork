//
//  CFBaseTabBarViewController.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit
import ESTabBarController_swift

public class CFNavigationVC: UINavigationController {
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
    
}

public class CFBaseTabBarViewController {
    
    static public func tabbarWithNavigationStyle() -> ESTabBarController {
        //初始化tabBarController
        let tabBarController = ESTabBarController()
        //详情参见 ESTabBarController 用法
        return tabBarController
    }
}
