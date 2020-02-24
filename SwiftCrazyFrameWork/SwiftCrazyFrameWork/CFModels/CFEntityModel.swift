//
//  CFEntityModel.swift
//  SwiftCrazyFrameWork
//  实体基类 (所有其他实体类可继承该类)
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//
import HandyJSON
import RealmSwift

open class CFEntityModel:Object, HandyJSON {
    @objc dynamic var pid = 0
    
    //设置主键
    override open class func primaryKey() -> String? {
        return "pid"
    }
    required public init() {}
}

