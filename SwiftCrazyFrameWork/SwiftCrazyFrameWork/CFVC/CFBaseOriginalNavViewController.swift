//
//  CFBaseOriginalNavViewController.swift
//  SwiftCrazyFrameWork
//  原始的导航栏 ViewController
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit

public class CFBaseOriginalNavViewController: CFBaseViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
            /*
             如果不设置BackgroundImage 背景图片  界面内的相对于顶部的约束就不会 自动适配到导航下方
             而是会从view顶部开始，向上被导航遮盖住
             */
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            if navi.viewControllers.count > 1 {
                let leftBtn = UIButton()
                leftBtn.sizeToFit()
                leftBtn.setImage(UIImage(named: "nav_back_white"), for: .normal)
                leftBtn.addTarget(self, action: #selector(originalNavBack), for: .touchUpInside)
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
            }
        }
    }
    
    @objc public func originalNavBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension CFBaseOriginalNavViewController {
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
