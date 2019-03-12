//
//  WalletController.swift
//  PaylineSDK
//
//  Created by Rayan Mehdi on 05/03/2019.
//

import Foundation

public final class WalletController: WebController {
    
    // MARK: - Public Interface
    
    public init(presentingViewController: UIViewController, delegate: WalletControllerDelegate) {
        super.init(presentingViewController: presentingViewController)
        self.delegate = delegate
    }
    
    public func manageWebWallet(environment: URL) {
        presentingViewController.present(webViewController, animated: true, completion: nil)
        webViewController.loadUrl(environment)
    }
    
    override func plWebViewControllerDidRequestClose(_ plWebViewController: PLWebViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal Interface
    
    weak var delegate: WalletControllerDelegate?
    
    override func handleReceivedEvent(_ event: ScriptEvent) {
        switch event {
        case .didShowState(let state):
            delegate?.walletControllerDidShowWebWebWallet(self)
        default:
            break
        }
    }
    
}
