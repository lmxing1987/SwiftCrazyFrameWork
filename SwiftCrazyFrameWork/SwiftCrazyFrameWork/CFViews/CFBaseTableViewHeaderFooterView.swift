//
//  CFBaseTableViewHeaderFooterView.swift
//  SwiftCrazyFrameWork
//  TableViewHeaderFooterView 基类
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit
import Reusable

public class CFBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        cf_configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func cf_configUI() {}
}
