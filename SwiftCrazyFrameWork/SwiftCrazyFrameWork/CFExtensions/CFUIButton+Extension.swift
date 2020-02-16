//
//  CFUIButton+Extension.swift
//  SwiftCrazyFrameWork
//  UIButton 扩展
//  Created by mxlai on 2020/2/15.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - 快速设置按钮 并监听点击事件
private var disposeBag = DisposeBag()
typealias buttonClick = (()->()) // 定义数据类型(其实就是设置别名)
extension UIButton {
    /// 快速创建按钮 setImage: 图片名 action:点击事件的回调
    convenience init(setImage:String, action:@escaping buttonClick){
        self.init()
        self.frame = frame
        self.setImage(UIImage(named:setImage), for: UIControl.State.normal)
        self.rx.tap.subscribe({ _ in
                action()
        }).disposed(by: disposeBag)
        self.sizeToFit()
    }
    convenience init(titleString:String, action:@escaping buttonClick){
        self.init()
        self.frame = frame
        self.setTitle(titleString, for: .normal)
        self.rx.tap.subscribe({ _ in
            action()
        }).disposed(by: disposeBag)
        self.sizeToFit()
    }
    /// 快速创建按钮 setImage: 图片名 frame:frame action:点击事件的回调
    convenience init(setImage:String, frame:CGRect, action: @escaping buttonClick){
        self.init( setImage: setImage, action: action)
        self.frame = frame
    }
    /// 快速创建按钮 titleString:title  frame:frame action:点击事件的回调
    convenience init(titleString:String, frame:CGRect, action: @escaping buttonClick){
        self.init(titleString: titleString, action: action)
        self.frame = frame
    }
}

// MARK: - 倒计时
extension UIButton {
    // MARK:倒计时 count:多少秒 默认倒计时的背景颜色gray
    /// 倒计时 count:多少秒 默认倒计时的背景颜色gray
    public func cf_countDown(count: Int){
       self.cf_countDown(count: count, countDownBgColor: UIColor.gray)
    }
    // MARK:倒计时 count:多少秒 countDownBgColor:倒计时背景颜色
    /// 倒计时 count:多少秒 countDownBgColor:倒计时背景颜色
    public func cf_countDown(count: Int, countDownBgColor:UIColor){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = countDownBgColor
        var remainingCount: Int = count {
            willSet {
                setTitle("重新发送(\(newValue))", for: .normal)
                if newValue <= 0 {
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
}
