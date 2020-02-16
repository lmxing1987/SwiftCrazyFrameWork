//
//  CFBaseWebViewController.swift
//  SwiftCrazyFrameWork
//  WebViewController
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit
import WebKit

public class CFBaseWebViewController: CFBaseOriginalNavViewController {
    
    var request: URLRequest!
    let messageName = "web" //与H5约定的字段
    
    
    lazy var webView: WKWebView = {
        let ww = WKWebView()
        ww.allowsBackForwardNavigationGestures = true
        ww.navigationDelegate = self
        ww.uiDelegate = self;
        return ww
    }()
    
    lazy var progressView: UIProgressView = {
        let pw = UIProgressView()
        pw.trackImage = UIImage.init(named: "nav_bg")
        pw.progressTintColor = UIColor.white
        return pw
    }()
    
    convenience init(url: String?) {
        self.init()
        self.request = URLRequest(url:  URL(string: url ?? "")!)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    }
    
    // 为了配合调取原生 需要在viewDidAppear、viewWillDisappear里实现
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.webView.configuration.userContentController.userScripts.count == 0 {
            self.webView.configuration.userContentController.add(self, name: messageName)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: messageName)
    }
    
    // 先走 configUI 再走viewDidLoad   configUI是上个父类继承的
    override public func cf_configUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))}
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    override public func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"),
                                                            target: self,
                                                            action: #selector(reload))
    }
    
    @objc public func reload() {
        webView.reload()
    }
    
    override public func originalNavBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension CFBaseWebViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    //与H5配合字段的的调取原生
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == messageName {
            
        }
    }
    
    
    override public func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
