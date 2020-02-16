//
//  CFData+Extension.swift
//  SwiftCrazyFrameWork
//  Data 扩展
//  Created by mxlai on 2020/2/14.
//  Copyright © 2020 mxlai. All rights reserved.
//

import CommonCrypto
extension Data {
    /// 获取Data 的MD5字符串
    func cf_getMD5String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = withUnsafeBytes { (bytes) in
            CC_MD5(bytes, CC_LONG(count), &digest)
        }
        var digestHex = ""
        for index in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}
