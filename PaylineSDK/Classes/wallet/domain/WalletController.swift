//
//  WalletController.swift
//  PaylineSDK
//
//  Created by Rayan Mehdi on 05/03/2019.
//

import Foundation

/**
 * Le WalletController s'e occupe d'afficher une webview en plein écran et de charger l'URL de gestion de portefeuille. Il communique avec l'application via son delegate.
 *
 */

public final class WalletController: WebController {
    
    // MARK: - Public Interface
    
    /**
     * Init
     *
     * - Parameters:
     *   - presentingViewController: ViewController affichant le walletController
     *   - delegate: Delegate walletController
     */
    public init(presentingViewController: UIViewController, delegate: WalletControllerDelegate) {
        super.init(presentingViewController: presentingViewController)
        self.delegate = delegate
    }
    
    /**
     * Affiche le porte-monnaie
     *
     * - Parameter environment: url qui redirige la webView vers le porte-monnaie
     */
    
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
        case .didShowState:
            delegate?.walletControllerDidShowWebWebWallet(self)
        default:
            break
        }
    }
    
}
