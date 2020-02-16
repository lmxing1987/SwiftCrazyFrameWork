//
//  CFRefresh.swift
//  SwiftCrazyFrameWork
//  下拉刷新效果
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var cf_header: MJRefreshHeader {
        get { return mj_header! }
        set { mj_header = newValue }
    }
    
    var cf_footer: MJRefreshFooter {
        get { return mj_footer! }
        set { mj_footer = newValue }
    }
}

public class CFRefreshHeader: MJRefreshGifHeader {
    override public func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
    }
}

public class CFRefreshAutoHeader: MJRefreshHeader {}

public class CFRefreshFooter: MJRefreshBackNormalFooter {}

public class CFRefreshAutoFooter: MJRefreshAutoFooter {}


public class CFRefreshDiscoverFooter: MJRefreshBackGifFooter {
    
    override open func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel?.isHidden = true
        refreshingBlock = { self.endRefreshing() }
    }
}

public class CFRefreshTipKissFooter: MJRefreshBackFooter {
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(named: "refresh_kiss")
        return iw
    }()
    
    override open func prepare() {
        super.prepare()
     //   backgroundColor = UIColor(r: 242, g: 242, b: 242, alpha: 1)
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override open func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tip
    }
}

