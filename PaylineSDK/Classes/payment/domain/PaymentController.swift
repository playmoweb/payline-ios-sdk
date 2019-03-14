//
//  PaymentController.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation
import UIKit
import WebKit

/**
 Le PaymentController dirige le tunnel de paiement. Il expose des fonctionnes natives pour démarrer et arrêter le tunnel de paiement, aussi bien que des fonctions javascript pour interroger et modifier le paiement en cours. Finalement, il communique les événements de la procédure via son delegate
 */
public final class PaymentController: WebController {
    
    // MARK: - Public Interface
    
    public init(presentingViewController: UIViewController, delegate: PaymentControllerDelegate) {
        super.init(presentingViewController: presentingViewController)
        self.delegate = delegate
    }
    
    /**
     * Affiche la liste des moyens de paiement
     *
     * [PW-API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     *
     * - Parameter environment: Url qui redirige la webView vers la liste des moyens de paiement
     */
    
    public func showPaymentForm(environment: URL) {
        presentingViewController.present(webViewController, animated: true, completion: nil)
        webViewController.loadUrl(environment)
    }
    
    /**
     * Mise à jour des informations de la session de paiement (adresses, montant,...) après l'initialisation du widget
     * et avant la finalisation du paiement.
     *
     * [PW-API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     * - Parameter webPaymentData: données qui correspondent aux informations de paiement, de la commande et de l'acheteur
     *
     *
     */
    public func updateWebPaymentData(_ webPaymentData: String) {
        scriptHandler.execute(action: PaymentAction.updateWebPaymentData(data: webPaymentData), in: webViewController.webView, callback: nil)
    }
    
    
    /**
     * Permet de connaitre l’environnement : production ou homologation. La fonction retourne true ou false.
     *
     * [PW-API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     */
    public func getIsSandbox() {
        scriptHandler.execute(action: PaymentAction.isSandbox, in: webViewController.webView, callback: { [weak self] (result, _) in
            guard let strongSelf = self else { return }
            guard let isSandbox = result as? Bool else { return }
            self?.delegate?.paymentController(strongSelf, didGetIsSandbox: isSandbox)
        })
    }
    
    /**
     * Met fin à la vie du jeton de session web
     *
     * [PW-API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     *
     * - Parameters:
     *   - isHandledByMerchant: isHandledByMerchant est à true si l'action de supprimer le jeton de session web vient du marchand
     *   - additionalData: test
     *
     */
    
    public func endToken(additionalData: Encodable?, isHandledByMerchant: Bool) {
        scriptHandler.execute(action: PaymentAction.endToken(additionalData: additionalData, isHandledByMerchant: isHandledByMerchant), in: webViewController.webView, callback: nil)
    }
    /**
     * Renvoie la clé du language du widget (passé dans la trame DoWebPayment)
     *
     * [PW-API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     */
    public func getLanguage() {
        scriptHandler.execute(action: PaymentAction.getLanguage, in: webViewController.webView) { [weak self] (result, _) in
            guard let strongSelf = self else { return }
            guard let language = result as? String else { return }
            self?.delegate?.paymentController(strongSelf, didGetLanguage: language)
        }
    }
    
    
    /**
     * Renvoie une information du contexte grâce à sa clé
     *
     * [PW-API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     *
     * - Parameter key: key correspond à la clé de la donnée que l'on veut récupérer
     *
     */
    public func getContextInfo(key: ContextInfoKey) {
        scriptHandler.execute(action: PaymentAction.getContextInfo(key: key), in: webViewController.webView) { [weak self] (result, _) in
            
            guard let strongSelf = self else { return }
            
            switch key {
                
            case .paylineAmountSmallestUnit,
                 .paylineCurrencyDigits:
                guard let contextResult = result as? Int else { return }
                let contextInfoResult = ContextInfoResult.int(key, contextResult)
                strongSelf.delegate?.paymentController(strongSelf, didGetContextInfo: contextInfoResult)
                
            case .paylineCurrencyCode,
                 .paylineBuyerFirstName,
                 .paylineBuyerLastName,
                 .paylineBuyerShippingAddressStreet2,
                 .paylineBuyerShippingAddressCountry,
                 .paylineBuyerShippingAddressName,
                 .paylineBuyerShippingAddressStreet1,
                 .paylineBuyerShippingAddressCityName,
                 .paylineBuyerShippingAddressZipCode,
                 .paylineBuyerMobilePhone,
                 .paylineBuyerShippingAddressPhone,
                 .paylineBuyerIp,
                 .paylineFormattedAmount,
                 .paylineOrderDate,
                 .paylineOrderRef,
                 .paylineOrderDeliveryMode,
                 .paylineOrderDeliveryTime:
                guard let contextResult = result as? String else { return }
                let contextInfoResult = ContextInfoResult.string(key, contextResult)
                strongSelf.delegate?.paymentController(strongSelf, didGetContextInfo: contextInfoResult)
                
            case .paylineOrderDetails:
                guard let contextResult = result as? [[String: Any]] else { return }
                let contextInfoResult = ContextInfoResult.objectArray(key, contextResult)
                self?.delegate?.paymentController(strongSelf, didGetContextInfo: contextInfoResult)
            }
        }
    }
    
    // MARK: - Internal Interface
    
    weak var delegate: PaymentControllerDelegate?
    
    override func plWebViewControllerDidFinishLoadingWithSuccess(_ plWebViewController: PLWebViewController) {
      //  delegate?.paymentControllerDidShowPaymentForm(self)
    }
    
    override func plWebViewControllerDidRequestClose(_ plWebViewController: PLWebViewController) {
        self.endToken(additionalData: nil, isHandledByMerchant: true)
    }
    
    override func handleReceivedEvent(_ event: ScriptEvent) {
        switch event {
            
        case .didShowState(let state):
            handleDidShowState(state: state)
            
        case .finalStateHasBeenReached(let state):
            handleFinalStateHasBeenReached(state: state)
            
        case .didEndToken(let state):
            finishPayment(state: state)
        }
    }
    
    private func handleDidShowState(state: WidgetState) {
        
        switch state {
            
        case .paymentMethodsList,
             .manageWebWallet:
            delegate?.paymentControllerDidShowPaymentForm(self)
             self.webViewController.closeButton?.isHidden = false
            
        case .paymentRedirectNoResponse:
            self.webViewController.closeButton?.isHidden = true
            print(state.rawValue)
            
        case .paymentFailureWithRetry,
             .paymentMethodNeedsMoreInfo,
             .activeWaiting,
             .paymentCanceledWithRetry:
            // ignored
            break

        default:
            break
        }
    }
    
    private func handleFinalStateHasBeenReached(state: WidgetState) {
            finishPayment(state: state)
            self.webViewController.closeButton?.isHidden = false
    }
    
    private func finishPayment(state: WidgetState) {
        delegate?.paymentControllerDidFinishPaymentForm(self, withState: state)
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
