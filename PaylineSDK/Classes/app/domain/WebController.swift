//
//  WebController.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import UIKit
import WebKit

public class WebController: PLWebViewControllerDelegate {
    
    // MARK: - Internal Interface
    
    let scriptHandler = ScriptHandler()
    
    lazy var webViewController: PLWebViewController = {
        let wvc = PLWebViewController()
        wvc.delegate = self
        wvc.listenForEventNames(scriptHandler.handledEvents)
        return wvc
    }()
    
    let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        
        // TODO: Appearance ?
    }
    
    func plWebViewControllerDidFinishLoadingWithSuccess(_ plWebViewController: PLWebViewController) {}
    
    func plWebViewController(_ plWebViewController: PLWebViewController, didFinishLoadingWithError error: Error) {
        debugPrint(error)
    }
    
    func plWebViewController(_ plWebViewController: PLWebViewController, didReceive message: WKScriptMessage) {
        scriptHandler.handle(message: message) { [weak self] in
            self?.handleReceivedEvent($0)
        }
    }
    
    func plWebViewControllerDidRequestClose(_ plWebViewController: PLWebViewController) {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    func handleReceivedEvent(_ event: ScriptEvent) {
        // TODO: subclasses override this
    }
}
