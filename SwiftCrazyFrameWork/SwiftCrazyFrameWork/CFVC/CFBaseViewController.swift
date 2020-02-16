//
//  CFBaseViewController.swift
//  SwiftCrazyFrameWork
//  viewController 基类
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxSwift
public class CFBaseViewController: UIViewController {
    
    var contentView: UIScrollView? {
        didSet {
            if (contentView?.isKind(of: UITableView.self))! {
                let tab = contentView as? UITableView
                tab?.tableFooterView = UIView()
            }
            contentView?.emptyDataSetSource = self
            contentView?.emptyDataSetDelegate = self
            contentView?.backgroundColor = UIColor.white
            //如果修改绑定别的类型的表头/表尾 需要重新绑定新的方法
            contentView?.cf_header = CFRefreshHeader { [weak self] in self?.cf_loadData() }
            contentView?.cf_footer = CFRefreshFooter(refreshingBlock: { [weak self] in self?.cf_loadMoreData() })
            
        }
    }
    
    var isLoading: Bool = false
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 解决ios11 由于安全区域safeArea问题造成的表的向下偏移
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        cf_configUI()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func cf_configUI() {}
    
    func cf_emptyLoading() { cf_loadData() }
    
    @objc func cf_loadData()  {}
    @objc func cf_loadMoreData()  {}
    
}

extension CFBaseViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "NO Data!"
        let font = UIFont.systemFont(ofSize: 17)
        let textColor = UIColor.red
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Safari cannot open the page because your iPhone is not connected to the Internet."
        let font = UIFont(name: "Lato-Regular", size: 16)
        let textColor = UIColor.gray
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        paragraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16),
                          NSAttributedString.Key.foregroundColor: textColor,
                          NSAttributedString.Key.paragraphStyle: paragraph]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if isLoading {
            return UIImage(named: "loading_imgBlue_78x78")
        } else {
            return UIImage(named: "yaofan")
        }
    }
    
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
 
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue  = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = "重新点击获取"
        let font = UIFont.systemFont(ofSize: 17)
        let textColor = state == .normal ? UIColor.blue : UIColor.white
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        let imageName = state == .normal ? "button_background_foursquare_normal" : "button_background_foursquare_highlight"
        let capInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        let rectInsets = UIEdgeInsets(top: 0.0, left: -10, bottom: 0.0, right: -10)
        // 拉伸区域
        let resizableImage = UIImage(named: imageName)?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        //图片位置相对文字偏移
        let newImage = resizableImage?.withAlignmentRectInsets(rectInsets)
        return newImage
    }
    
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
   
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        var vOffset: CGFloat = 0
        if let top = contentView?.contentInset.top, top > 0 {
            vOffset = top - 75
        }
        return -vOffset
    }
    //组件彼此分离（默认分隔为11点）
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    // DELEGATE
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return isLoading
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.isLoading = true
        cf_emptyLoading()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.isLoading = true
        cf_emptyLoading()
    }
}
