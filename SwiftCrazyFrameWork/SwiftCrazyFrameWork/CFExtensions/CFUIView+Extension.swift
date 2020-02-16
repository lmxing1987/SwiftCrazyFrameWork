//
//  CFUIView+Extension.swift
//  SwiftCrazyFrameWork
//  UIView 扩展
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - 尺寸相关
    var cf_x:CGFloat{
        get{
            return self.frame.origin.x
        } set{
            self.frame.origin.x = newValue
        }
    }
    
    var cf_y:CGFloat{
        get{
            return self.frame.origin.y
        }set{
            self.frame.origin.y = newValue
        }
    }
    
    var cf_width:CGFloat{
        get{
            return self.frame.size.width
        }set{
            self.frame.size.width = newValue
        }
    }
    
    var cf_height:CGFloat{
        get{
            return self.frame.size.height
        }set{
            self.frame.size.height = newValue
        }
    }
    
    var cf_size:CGSize{
        get{
            return self.frame.size
        }set{
            self.frame.size = newValue
        }
    }
    var cf_centerX:CGFloat{
        get{
            return self.center.x
        }
        set{
            self.cf_centerX = newValue
        }
    }
    var cf_centerY:CGFloat{
        get{
            return self.center.y
        }
        set{
            self.cf_centerY = newValue
        }
    }
    // MARK: - 尺寸裁剪相关
    /// 添加圆角  radius: 圆角半径
    func cf_addRounded(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 切圆
    func cf_cutRoundImageView() {
        let radius = self.frame.size.width / 2;
        cf_addRounded(radius: radius, corners: .allCorners)
    }
    
    /// 添加部分圆角(有问题右边且不了) corners: 需要实现为圆角的角，可传入多个 radius: 圆角半径
    func cf_addRounded(radius:CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer;
    }

    // MARK: - 添加边框
    /// 添加边框 width: 边框宽度 默认黑色
    func cf_addBorder(width : CGFloat) { // 黑框
        self.layer.borderWidth = width;
        self.layer.borderColor = UIColor.black.cgColor;
    }
    /// 添加边框 width: 边框宽度 borderColor:边框颜色
    func cf_addBorder(width : CGFloat, borderColor : UIColor) { // 颜色自己给
        self.layer.borderWidth = width;
        self.layer.borderColor = borderColor.cgColor;
    }
    /// 添加圆角和阴影
    func cf_addRoundedOrShadow(radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1 // 不透明度
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    /// UIView 转 UIImage
    func cf_imageFromView() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var cf_blurView: BlurView {
        get {
            if let cf_blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return cf_blurView
            }
            self.cf_blurView = BlurView(to: self)
            return self.cf_blurView
        }
        set(cf_blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                cf_blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                cf_applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    cf_applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                cf_applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func cf_applyBlurEffect() {
            blur?.removeFromSuperview()
            
            cf_applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func cf_applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.cf_addAlignedConstrains()
            vibrancyView.cf_addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func cf_addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        cf_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        cf_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        cf_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        cf_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func cf_addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}
