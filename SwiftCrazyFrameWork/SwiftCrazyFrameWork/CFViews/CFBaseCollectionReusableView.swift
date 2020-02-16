//
//  CFBaseCollectionReusableView.swift
//  SwiftCrazyFrameWork
//  CollectionReusableView 基类
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import Reusable

public class CFBaseCollectionReusableView: UICollectionReusableView, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        cf_configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func cf_configUI() {}
}
