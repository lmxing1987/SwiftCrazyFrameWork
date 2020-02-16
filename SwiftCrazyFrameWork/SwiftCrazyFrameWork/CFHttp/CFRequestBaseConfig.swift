//
//  CFRequestBaseConfig.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/13.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import RxSwift


struct ResponseData<T: HandyJSON>: HandyJSON {
    var message:String?
    var data: T?
    var stateCode: Int = 0
}
/// 请求配置
public class CFRequestConfig{
    // 服务器请求地址
    static var kBaseUrl: String = ""
}
extension ObservableType where E == Response {
    public func mapModel<T: HandyJSON>(_ type: T.Type) throws -> Observable<T> {
               return flatMap { response -> Observable<T> in
            return Observable.just(response.mapModelObser(T.self))
        }
    }
}

extension Response {
    
    func mapModelObser<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let mode = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            fatalError() }
        return mode
    }
    
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let mode = JSONDeserializer<T>.deserializeFrom(json: jsonString) else { throw MoyaError.jsonMapping(self) }
        return mode
    }
    
}
/// ViewModel 需要实现的协议
public protocol CFViewModelProtocol {
    func getResponseType<T: HandyJSON>(_ type: T.Type) -> T.Type
    func getData<T: HandyJSON>(_ type: T) -> T
}
extension MoyaProvider {
    
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    viewModel: CFViewModelProtocol,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            let responseType = viewModel.getResponseType(T.self)
            guard let responseData = try? result.value?.mapModel(responseType.self) else {
                completion(nil)
                return
            }
            let returnData = viewModel.getData(responseData)
            completion(returnData)
        })
    }
}

