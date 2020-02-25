//
//  CFRealmDBHelperUtils.swift
//  SwiftCrazyFrameWork
//  Realm 本地数据存储缓存
//  Created by mxlai on 2020/2/24.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import RealmSwift

open class CFRealmDBHelperUtils: NSObject{
    static public var schemaVersion:UInt64 = 0
    static public func realmConfig(){
        let config = Realm.Configuration(
            schemaVersion: self.schemaVersion,
             migrationBlock: { migration, oldSchemaVersion in
                     if (oldSchemaVersion < 0) {}
             })
        Realm.Configuration.defaultConfiguration = config
    }
    static let realm = try! Realm()
    
    /// 新增存储model
    /// - Parameter model: Object model
    class public func addModel <T: Object> (model: T){
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {}
    }
    
    /// 查询model 列表
    /// - Parameters:
    ///   - model: 模型
    ///   - filter: 条件
    class public func findModel <T: Object> (model: T.Type, filter: String? = nil) -> [T]{
        
        var results : Results<T>
        
        if filter != nil {
            results =  realm.objects(model.self).filter(filter!)
        }else {
            results = realm.objects(model.self)
        }
        guard results.count > 0 else { return [] }
        var modelArray = [T]()
        for model in results{
            modelArray.append(model)
        }
        return modelArray
    }
    
    /// 查询一条数据
    /// - Parameters:
    ///   - model: 模型
    ///   - filter: 筛选条件
    class public func findOneModel <T: Object> (model: T.Type, filter: String? = nil) -> T? {
        let modelArray = self .findModel(model: model, filter: filter)
        guard modelArray.count > 0 else { return nil }
        return modelArray[0]
    }
    
    /// 修改模型
    /// - Parameter model: 被修改模型
    class public func updateModel <T: Object> (model: T){
        do {
            try realm.write {
                realm.add(model, update: Realm.UpdatePolicy.modified)
               
            }
        }catch{}
    }
    
    /// 按模型删除
    /// - Parameter model: 需删除的模型
    class public func deleteModel <T: Object> (model: T){
        do {
            try realm.write {
                realm.delete(model)
            }
        } catch {}
    }
    
}
