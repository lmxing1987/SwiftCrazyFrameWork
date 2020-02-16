//
//  CFUIImage+Extension.swift
//  SwiftCrazyFrameWork
//  UIImage 扩展
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    
    /// 缩放图片到指定size
    /// - Parameter size: size
    func cf_scaleImage(_ size: CGSize) -> UIImage {
        //创建上下文
        UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /// 图片裁剪内切圆  异步绘制
    /// - Parameters:
    ///   - image: image
    ///   - resultBlock: 返回
    class func cf_clipCircleImage(_ image: UIImage?,
                                _ resultBlock: @escaping(_ newImage: UIImage?)->()) {
        
        guard let realImage = image else { return }
        //全局队列的异步线程
        DispatchQueue.global().async {
            // 获取图片上下文章
            UIGraphicsBeginImageContext(realImage.size)
            // 利用贝塞尔曲线裁剪
            let clipBezier = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: realImage.size.width, height: realImage.size.height))
           //把路径设置为裁剪区域(超出裁剪区域以外的内容会被自动裁剪掉)
            clipBezier.addClip()
            //把图片绘制到上下文当中
            realImage.draw(at: CGPoint.zero)
            // 获取当前的上下文
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            // 关闭上下文
            UIGraphicsEndImageContext()
            // 回到主线程 完成回调
            DispatchQueue.main.async {
                resultBlock(newImage)
            }
        }
    }
    /// 将图片裁剪成指定比例（多余部分自动删除）
    func cf_centerSubImage(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
}
// 图片颜色
extension UIImage {
     
    /// 根据坐标获取图片中的像素颜色值
    func cf_pixelColor(x: Int, y: Int) -> UIColor? {
         
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
         
        let provider = self.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
         
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
         
        let r = CGFloat(data![pixelData]) / 255.0
        let g = CGFloat(data![pixelData + 1]) / 255.0
        let b = CGFloat(data![pixelData + 2]) / 255.0
        let a = CGFloat(data![pixelData + 3]) / 255.0
         
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
