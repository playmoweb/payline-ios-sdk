//
//  PLWebViewController.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation
import UIKit
import WebKit

class PLWebViewController: UIViewController {
    
    weak var webViewDelegate: PLWebViewControllerDelegate?
    var closeButton: UIBarButtonItem?
    
    lazy var webView: WKWebView = {
        let wkwv = WKWebView()
        wkwv.translatesAutoresizingMaskIntoConstraints = false
        wkwv.navigationDelegate = self
        wkwv.scrollView.bounces = false
        return wkwv
    }()
    
    private lazy var progressView: UIProgressView = {
        let prv = UIProgressView(progressViewStyle: .default)
        prv.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        prv.progressTintColor = PLTheme.shared.primaryColor
        view.addSubview(prv)
        return prv
    }()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func loadView() {
        super.loadView()
        setupNavigationBar()
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        if #available(iOS 11.0, *) {
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        let safeAreaBackground = UIView()
        safeAreaBackground.translatesAutoresizingMaskIntoConstraints = false
        safeAreaBackground.backgroundColor = PLTheme.shared.bottomSafeAreaColor
        view.addSubview(safeAreaBackground)
        
        if #available(iOS 11.0, *) {
            safeAreaBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        }
        safeAreaBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        safeAreaBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        safeAreaBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = PLTheme.shared.primaryColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let closeButtonImage = UIImage(named: "closeIcon", in: Bundle(for: PLWebViewController.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)

        closeButton = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action: #selector(close))
        closeButton?.tintColor = PLTheme.shared.secondaryColor
        
        self.navigationItem.rightBarButtonItem  = closeButton
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return PLTheme.shared.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\WKWebView.estimatedProgress, options: [NSKeyValueObservingOptions.new]) { [weak self] (_, change) in
            if let progress = change.newValue {
                self?.progressView.progress = Float(progress)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var topInset = CGFloat(0)
        if #available(iOS 11, *) {
            topInset = view.safeAreaInsets.top
        }
        progressView.frame = CGRect(x: 0, y: topInset, width: view.bounds.width, height: 2)
    }
    
    func loadUrl(_ url: URL) {
//        webView.load(URLRequest(url: url))
        tempFixLoadUrl(url)
    }
    
    // TODO: Delete me when fixed
    private func tempFixLoadUrl(_ url: URL) {
        webView.load(URLRequest(url: URL(string: "about:blank")!))
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    func listenForEventNames(_ eventNames: [ScriptEvent.Name]) {
        for eventName in eventNames {
            webView.configuration.userContentController.add(self, name: eventName.rawValue)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }
    
    @objc func close() {
        webViewDelegate?.plWebViewControllerDidRequestClose(self)
    }
    
}

// MARK: - WKWebView
extension PLWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        webViewDelegate?.plWebViewControllerDidFinishLoadingWithSuccess(self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        webViewDelegate?.plWebViewController(self, didFinishLoadingWithError: error)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
}

// MARK: - WKScriptMessageHandler
extension PLWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        webViewDelegate?.plWebViewController(self, didReceive: message)
    }
}

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
