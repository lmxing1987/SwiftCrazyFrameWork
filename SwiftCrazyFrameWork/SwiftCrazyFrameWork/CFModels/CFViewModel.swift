//
//  CFViewModel.swift
//  SwiftCrazyFrameWork
//  ViewModel基类(所有viewmodel继承本类)
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

public class CFViewModel: CFViewModelProtocol {

    
    struct ReturnData<T: HandyJSON>: HandyJSON {
        var message:String?
        var returnData: T?
        var stateCode: Int = 0
    }

    struct ResponseData<T: HandyJSON>: HandyJSON {
        var code: Int = 0
        var data: ReturnData<T>?
    }
    public func getResponseType<T: HandyJSON>(_ type: T.Type) -> T.Type {
        return ResponseData<T>.self as! T.Type
    }
    public func getData<T>(_ type: T) -> T where T : HandyJSON {
        let retuenDta = type as! ReturnData<T>
        return retuenDta.returnData!
    }
    
    var dataModel = Variable(CFEntityModel())
    func getList(_ resultBlock: @escaping(_ isNoData: Bool)->()) {
        
        let target = CFRequest.get(suffixUrl:"", params:[:])
        shareProvider.request(target, model: CFEntityModel.self, viewModel: self) { [weak self] (resultModel) in

        guard let model = resultModel else {
            return
        }
         self?.dataModel.value = model
         resultBlock(true)
        }
    }
    
}
