//
//  CFEntityModel.swift
//  SwiftCrazyFrameWork
//  实体基类 (所有其他实体类可继承该类)
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//
import HandyJSON

public class CFEntityModel: HandyJSON {
    var mPK: String?
    required public init() {}
}

