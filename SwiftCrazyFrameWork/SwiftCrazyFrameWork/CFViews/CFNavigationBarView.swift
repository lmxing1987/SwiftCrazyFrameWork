//
//  CFNavigationBarView.swift
//  SwiftCrazyFrameWork
//  顶部导航界面
//  Created by mxlai on 2020/2/11.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit

fileprivate let CFDefaultTitleSize:CGFloat = 18
fileprivate let CFDefaultTitleColor = kBLACK_COLOR
fileprivate let CFDefaultBgColor = kWHITE_COLOR
fileprivate let CFScreenWidth = kScreenWidth

public class CFNavigationBarView: UIView {
    
    var onLeftBtnClick: (()->())?
    var onRightBtnClick: (()->())?

    var cfTitle: String? {
        willSet {
            cfTitleLabel.isHidden = false
            cfSearchbar.isHidden = true
            cfTitleLabel.text = newValue
        }
    }
    
    var cfTitleColor: UIColor? {
        willSet {
            cfTitleLabel.textColor = newValue
        }
    }
    var cfTitleFont: UIFont? {
        willSet {
            cfTitleLabel.font = newValue
        }
    }
    var cfBarBgColor: UIColor? {
        willSet {
            cfBackgroundImageView.isHidden = true
            cfBackgroundView.isHidden = false
            cfBackgroundView.backgroundColor = newValue
        }
    }
    var cfBarBgImage: UIImage? {
        willSet {
            cfBackgroundView.isHidden = true
            cfBackgroundImageView.isHidden = false
            cfBackgroundImageView.image = newValue
        }
    }
    
    
  // fileprivate UI variable
  lazy var cfTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CFDefaultTitleColor
        label.font = UIFont.systemFont(ofSize: CFDefaultTitleSize)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    lazy var cfSearchbar: UISearchBar = {
        let search = UISearchBar()
        search.barTintColor = UIColor.white
        let searchField = search.value(forKey: "searchField") as? UITextField
        if let cfField = searchField {
            cfField.layer.cornerRadius = 13.0
            cfField.layer.masksToBounds = true
            cfField.font = UIFont.boldSystemFont(ofSize: 13.0)
            let ploceColor = UIColor.cf_hex(hexString: "ffffff")
            let labe = cfField.value(forKey: "placeholderLabel") as? UILabel
            labe?.textColor = ploceColor
            cfField.backgroundColor = UIColor.cf_hex(hexString: "ffffff")
        }
        search.isHidden = true
        return search
    }()

  lazy var cfLeftBtn: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return button
    }()
 
 lazy var cfRightBtn: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textColor = UIColor.cf_hex(hexString: "333333")
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var cfBottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    fileprivate lazy var cfBackgroundView:UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var cfBackgroundImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    // 初始化的一些方法
   class func getCFNavigationBar() -> CFNavigationBarView {
        let frame = CGRect(x: 0, y: 0, width: CFScreenWidth, height: CGFloat(CFNavigationBarView.navBarBottom()))
        return CFNavigationBarView(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setUI()
    }
    
    func setUI() {
        addSubview(cfBackgroundView)
        addSubview(cfBackgroundImageView)
        addSubview(cfLeftBtn)
        addSubview(cfTitleLabel)
        for searchChidView in cfSearchbar.subviews {
            if searchChidView.isKind(of: UIView.self) {
              searchChidView.subviews[0].removeFromSuperview()
            }
        }
        addSubview(cfSearchbar)
        addSubview(cfRightBtn)
        addSubview(cfBottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
        cfBackgroundView.backgroundColor = CFDefaultBgColor
    }
    
    func updateFrame() {
        let top:CGFloat = CFNavigationBarView.isIphoneX() ? 44 : 20 + 6
        let margin:CGFloat = 5
        let buttonHeight:CGFloat = 35
        let buttonWidth:CGFloat = 40
        let titleLabelHeight:CGFloat = 44
        let titleLabelWidth:CGFloat = 180
        
        cfBackgroundView.frame = self.bounds
        cfBackgroundImageView.frame = self.bounds
        cfLeftBtn.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        cfLeftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cfRightBtn.frame = CGRect(x: CFScreenWidth-buttonWidth-margin, y: top, width: buttonWidth, height: buttonHeight)
        cfRightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cfTitleLabel.frame = CGRect(x: (CFScreenWidth-titleLabelWidth)/2.0, y: top - 6, width: titleLabelWidth, height: titleLabelHeight)
        cfSearchbar.frame = CGRect(x: margin + buttonWidth - 10, y: top + 2, width: CFScreenWidth - 2.0*buttonWidth - 2.0*margin + 20, height: buttonHeight - 4)
        cfBottomLine.frame = CGRect(x: 0, y: bounds.height-0.5, width: CFScreenWidth, height: 0.5)
    }
    
}
// MARK: - 导航的事件
extension CFNavigationBarView {
    
    func cf_setBottomLineHidden(hidden: Bool) {
        cfBottomLine.isHidden = hidden
    }
    
    func cf_setBackgroundAlpha(alpha: CGFloat) {
        cfBackgroundView.alpha = alpha
        cfBackgroundImageView.alpha = alpha
        cfBottomLine.alpha = alpha
    }
    
    func cf_setTintColor(color: UIColor) {
        cfLeftBtn.setTitleColor(color, for: .normal)
        cfRightBtn.setTitleColor(color, for: .normal)
        cfTitleLabel.textColor = color
    }
    
    //左右按钮的方法
    func cf_setLeftButton(normal: UIImage?, highlighted: UIImage?) {
        cf_setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    func cf_setLeftButton(image: UIImage?) {
        cf_setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    func cf_setLeftButton(title: String, titleColor: UIColor) {
        cf_setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    func cf_setRightButton(normal: UIImage?, highlighted: UIImage?) {
        cf_setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    func cf_setRightButton(image: UIImage?) {
        cf_setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    func cf_setRightButton(title: String, titleColor: UIColor) {
        cf_setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    // 左右按钮私有方法
    private func cf_setLeftButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        cfLeftBtn.isHidden = false
        cfLeftBtn.setImage(normal, for: .normal)
        cfLeftBtn.setImage(highlighted, for: .highlighted)
        cfLeftBtn.setTitle(title, for: .normal)
        cfLeftBtn.setTitleColor(titleColor, for: .normal)
    }
    private func cf_setRightButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        cfRightBtn.isHidden = false
        cfRightBtn.setImage(normal, for: .normal)
        cfRightBtn.setImage(highlighted, for: .highlighted)
        cfRightBtn.setTitle(title, for: .normal)
        cfRightBtn.setTitleColor(titleColor, for: .normal)
    }
}

// MARK: - 导航栏左右按钮事件
extension CFNavigationBarView {
    
   @objc func backClick()  {
        if let onClickBack = onLeftBtnClick {
            onClickBack()
        } else {
            let current = UIViewController.cf_currentViewController()
            current.cf_backToViewController(animated: true)
        }
    }
    
    @objc func rightClick()  {
        if let onRight = onRightBtnClick {
            onRight()
        }
    }
}

 //对于 X 的适配
extension CFNavigationBarView
{
    class func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    class func navBarBottom() -> Int {
        return self.isIphoneX() ? 88 : 64;
    }
    class func tabBarHeight() -> Int {
        return self.isIphoneX() ? 83 : 49;
    }
    class func screenWidth() -> Int {
        return Int(UIScreen.main.bounds.size.width)
    }
    class func screenHeight() -> Int {
        return Int(UIScreen.main.bounds.size.height)
    }
}
