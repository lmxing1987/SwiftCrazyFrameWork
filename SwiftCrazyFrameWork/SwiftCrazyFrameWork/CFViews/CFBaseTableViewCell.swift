//
//  CFBaseTableViewCell.swift
//  SwiftCrazyFrameWork
//  TableViewCell 基类
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit
import Reusable

public class CFBaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        cf_configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var entityModel: CFEntityModel?{
        didSet{
          guard let entityModel = entityModel else { return }
          // 设置界面数据
        }
    }
    
    open func cf_configUI() {}

}
