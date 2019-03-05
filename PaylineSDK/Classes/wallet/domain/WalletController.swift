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
    
    public func manageWebWallet(token: String, environment: URL) {
        presentingViewController.present(webViewController, animated: true, completion: nil)
        webViewController.loadUrl(environment)
    }
    
    // MARK: - Internal Interface
    
    weak var delegate: WalletControllerDelegate?
    
    override func handleReceivedEvent(_ event: ScriptEvent) {
        switch event {
        // TODO:
        default:
            break
        }
    }
    
}
