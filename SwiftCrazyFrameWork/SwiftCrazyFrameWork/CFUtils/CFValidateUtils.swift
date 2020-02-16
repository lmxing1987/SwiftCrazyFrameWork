//
//  CFValidateUtils.swift
//  SwiftCrazyFrameWork
//  验证规则
//  Created by mxlai on 2020/2/15.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation

public enum CFValidateUtils {
    case zipcode(_: String)     // 邮编
    case email(_: String)       // 邮箱
    case phoneNum(_: String)    // 手机
    case carNum(_: String)      // 车牌号
    case username(_: String)    // 登录名
    case password(_: String)    // 密码
    case nickname(_: String)    // 昵称
    case URL(_: String)         // 网址
    case IP(_: String)          // ip
    case idCard(_: String)      // 身份证号
    case numbers(_: String)     // 只包含数字
    case lettersAndNumbers(_: String) // 只包含字母和数字
    case chinese(_: String)     // 中文
    case bankCard(_: String)    // 银行卡号
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .zipcode(str):
            predicateStr = "^[1-9]\\d{5}(?!\\d)$"
            currObject = str
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,12}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        case let .idCard(str):
            predicateStr = "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)"
            currObject = str
        case let .numbers(str):
            predicateStr = "^[0-9]+$"
            currObject = str
        case let .lettersAndNumbers(str):
            predicateStr = "^[a-zA-Z0-9]{1,30}+$"
            currObject = str
        case let .chinese(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{0,100}$"
            currObject = str
        case let .bankCard(str):
            return self.cf_isBankCard(str)
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
    /// 验证银行卡
    func cf_isBankCard(_ cardNo: String) -> Bool {
        var oddSum = 0     //奇数求和
        var evenSum = 0    //偶数求和
        var allSum = 0
        
        let count = cardNo.count
        if  count < 15 || count > 19 {
            print("银行卡号位数不对，一般15-19位，该卡号\(count)位")
            return false
        }
        
        for (i, value) in cardNo.enumerated().reversed() {
            guard let t = Int(String.init(value)) else {
                print("银行卡号应该全是数组，你输入了其他字符")
                return false
            }
            let index = count - i
            if index % 2 == 0 {
                let temp = t * 2
                evenSum += temp > 9 ? temp - 9 : temp
            } else {
                oddSum += t
            }
        }
        allSum = oddSum + evenSum
        if allSum % 10 == 0 {
            print("💐、银行卡号格式正确")
            return true
        }
        print("银行卡号格式不对")
        return false
    }

}
