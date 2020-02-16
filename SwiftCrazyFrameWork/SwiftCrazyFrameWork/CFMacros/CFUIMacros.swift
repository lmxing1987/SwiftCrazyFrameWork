//  全局UI相关的常量
//  CFUIMacros.swift
//  SwiftCrazyFrameWork
//
//  Created by mxlai on 2020/2/10.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit
// MARK: - 屏幕差别
public let kScreenWidth = UIScreen.main.bounds.width
public let kScreenHeight = UIScreen.main.bounds.height
public let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
public let kTabBarHeight = kIsIphoneX ? 83 : 49
public let kNaviHeight = kIsIphoneX ? 88 : 64
public let kStatusHeight = kIsIphoneX ? 44 : 20
public let kBottomHeight = kIsIphoneX ? 34 : 0  //iphone X 底部角圆角的距离是34
public let kNavBarHeight = 44.0

// MARK: - View Frame
public func kCGRectOrigin(_ v: UIView) -> CGPoint { return v.frame.origin }
public func kCGRectSize(_ v: UIView) -> CGSize { return v.frame.size}
public func kCGRectX(_ v: UIView) -> CGFloat { return kCGRectOrigin(v).x }
public func kCGRectY(_ v: UIView) -> CGFloat { return kCGRectOrigin(v).y }
public func kCGRectW(_ v: UIView) -> CGFloat { return kCGRectSize(v).width }
public func kCGRectH(_ v: UIView) -> CGFloat { return kCGRectSize(v).height }
public func kCGRectMT(_ v: UIView, _ t: CGFloat) -> CGFloat { return kCGRectY(v)+kCGRectH(v)+t }
public func kCGRectML(_ v: UIView, _ t: CGFloat) -> CGFloat { return kCGRectX(v)+kCGRectW(v)+t }
// MARK: - 颜色
public func kRGBA (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor
{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
/// 样式  0x5B5B5B
///
/// - Parameters:
///   - color_vaule: 传入0x5B5B5B格式的色值
///   - alpha: 传入透明度
/// - Returns: 颜色
public func kColorFromRGB(color_vaule: UInt64, alpha: CGFloat = 1) -> UIColor {
    let redValue = CGFloat((color_vaule & 0xFF0000) >> 16)/255.0
    let greenValue = CGFloat((color_vaule & 0xFF00) >> 8)/255.0
    let blueValue = CGFloat(color_vaule & 0xFF)/255.0
    return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
}

public let kCLEAR_COLOR = UIColor.clear
public let kBLACK_COLOR = UIColor.black
public let kWHITE_COLOR = UIColor.white

// MARK: - 字体
public func kDEFAULT_FONT(_ s: CGFloat) -> UIFont { return UIFont.systemFont(ofSize: s) }
public func kDEFAULT_BOLDFONT(_ s: CGFloat) -> UIFont { return UIFont.boldSystemFont(ofSize: s)  }
// 普通字体
public let kH30 = kDEFAULT_FONT(30.0)
public let kH29 = kDEFAULT_FONT(29.0)
public let kH28 = kDEFAULT_FONT(28.0)
public let kH27 = kDEFAULT_FONT(27.0)
public let kH26 = kDEFAULT_FONT(26.0)
public let kH25 = kDEFAULT_FONT(25.0)
public let kH24 = kDEFAULT_FONT(24.0)
public let kH23 = kDEFAULT_FONT(23.0)
public let kH22 = kDEFAULT_FONT(22.0)
public let kH20 = kDEFAULT_FONT(20.0)
public let kH19 = kDEFAULT_FONT(19.0)
public let kH18 = kDEFAULT_FONT(18.0)
public let kH17 = kDEFAULT_FONT(17.0)
public let kH16 = kDEFAULT_FONT(16.0)
public let kH15 = kDEFAULT_FONT(15.0)
public let kH14 = kDEFAULT_FONT(14.0)
public let kH13 = kDEFAULT_FONT(13.0)
public let kH12 = kDEFAULT_FONT(12.0)
public let kH11 = kDEFAULT_FONT(11.0)
public let kH10 = kDEFAULT_FONT(10.0)
public let kH8 = kDEFAULT_FONT(8.0)

// 粗体
public let kHB20 = kDEFAULT_BOLDFONT(20.0)
public let kHB18 = kDEFAULT_BOLDFONT(18.0)
public let kHB16 = kDEFAULT_BOLDFONT(16.0)
public let kHB15 = kDEFAULT_BOLDFONT(15.0)
public let kHB14 = kDEFAULT_BOLDFONT(14.0)
public let kHB13 = kDEFAULT_BOLDFONT(13.0)
public let kHB12 = kDEFAULT_BOLDFONT(12.0)
public let kHB11 = kDEFAULT_BOLDFONT(11.0)
public let kHB10 = kDEFAULT_BOLDFONT(10.0)
public let kHB8 = kDEFAULT_BOLDFONT(8.0)




