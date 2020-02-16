//
//  CFRequest.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Moya
import HandyJSON
import MBProgressHUD

//当需要在header里面添加请求token或者时间戳等信息时可以传入这些配置
struct AuthPlugin: PluginType {
func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    UserDefaults.standard.synchronize()
    let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String
    let timestamp: Int = Date.cf_getCurrentTimeStamp()
    request.addValue("\(timestamp)", forHTTPHeaderField: "timestamp")
    if accessToken != nil {
        request.addValue(accessToken!, forHTTPHeaderField: "accessToken")
    }
//    print(request.allHTTPHeaderFields)
    return request
}
}
let LoadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = CFAppUtils.currentViewController else { return }
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
}
let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<CFRequest>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}
let authPlugin = AuthPlugin()
let shareProvider : MoyaProvider<CFRequest> = MoyaProvider<CFRequest>(requestClosure: timeoutClosure, plugins: [authPlugin])
let shareLoadingProvider = MoyaProvider<CFRequest>(requestClosure: timeoutClosure, plugins: [LoadingPlugin, authPlugin])

public enum CFRequest {
    
    //基本路由地址get、post请求
    case post(suffixUrl:String, params:[String:Any])
    case get(suffixUrl:String, params:[String:Any])
    //其它路由地址get、post请求
    case otherRequst(baseUrl:String, type:OtherBaseURLRequst)
    public enum OtherBaseURLRequst {
        case post(suffixUrl:String, params:[String:Any])
        case get(suffixUrl:String, params:[String:Any])
    }
}

extension CFRequest: TargetType {
   //路由地址
    public var baseURL: URL {
          let result = self.getConfigure()
          return URL(string: result.1)!
    }
    //具体地址
    public var path: String {
          let result = self.getConfigure()
          return result.2
    }
    //请求方式get、post
    public var method: Moya.Method {
          let result = self.getConfigure()
          return result.0
    }
    //单元测试所用
    public var sampleData: Data {
          return "{}".data(using: .utf8)!
    }
    //请求任务事件（这里附带上参数）
    public var task: Task {
        //request上传、upload上传、download下载
       let result = self.getConfigure()
       return .requestParameters(parameters: result.3, encoding: URLEncoding.default)
    }
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    private func getConfigure() -> (Moya.Method,String,String,[String:Any]) {
        switch self {
        case .get(suffixUrl: let suffixUrl, params: let params):
            return (.get, CFRequestConfig.kBaseUrl, suffixUrl,params)
        case .post(suffixUrl: let suffixUrl, params: let params):
            return (.post, CFRequestConfig.kBaseUrl, suffixUrl,params)
        case .otherRequst(baseUrl: let baseUrl, type: let type):
            switch type{
                case .get(suffixUrl: let suffixUrl, params: let params):
                      return (.get,baseUrl,suffixUrl,params)
                case .post(suffixUrl: let suffixUrl, params: let params):
                      return (.post,baseUrl,suffixUrl,params)
             }
        }
    }
}

