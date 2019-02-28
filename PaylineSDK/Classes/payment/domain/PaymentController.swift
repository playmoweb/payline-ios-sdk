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
 
 */
public final class PaymentController: WebController {
    
    // MARK: - Public Interface
    
    public init(presentingViewController: UIViewController, delegate: PaymentControllerDelegate) {
        super.init(presentingViewController: presentingViewController)
        self.delegate = delegate
    }
    
    public func showPaymentForm(token: String, environment: URL) {
        presentingViewController.present(webViewController, animated: true, completion: nil)
        webViewController.loadUrl(environment)
    }
    
    public func cancelPaymentForm(token: String) {
        endToken()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    public func updateWebPaymentData(_ webPaymentData: String) {
        
    }
    
    public func getIsSandbox() {
        scriptHandler.execute(action: PaymentAction.getLanguage, in: webViewController.webView, callback: { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            guard let language = result as? String else { return }
            self?.delegate?.paymentController(strongSelf, didGetLanguage: language)
        })
    }
    
    public func endToken() {
        scriptHandler.execute(action: PaymentAction.endToken, in: webViewController.webView) { [weak self] (result, error) in
            // TODO: handle result / error
            self?.presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func getLanguage() {
        scriptHandler.execute(action: PaymentAction.getLanguage, in: webViewController.webView) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            guard let language = result as? String else { return }
            self?.delegate?.paymentController(strongSelf, didGetLanguage: language)
        }
    }
    
    public func getContextInfo() {
        
    }
    
    public func finalizeShortCut() {
        scriptHandler.execute(action: PaymentAction.finalizeShortCut, in: webViewController.webView) { [weak self] (result, error) in
            self?.presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func getBuyerShortCut() {
        
    }
    
    // MARK: - Internal Interface
    
    weak var delegate: PaymentControllerDelegate?
    
    override func plWebViewControllerDidFinishLoadingWithSuccess(_ plWebViewController: PLWebViewController) {
        delegate?.paymentControllerDidShowPaymentForm(self)
    }
    
    override func handleReceivedEvent(_ event: ScriptEvent) {
        switch event {
        case .didShowState(let state):
            // TODO: ?
            switch state {
            case .paymentMethodsList:
                print(state.rawValue)
            case .paymentFailureWithRetry:
                print(state.rawValue)
            case .paymentMethodNeedsMoreInfo:
                print(state.rawValue)
            case .paymentRedirectNoResponse:
                print(state.rawValue)
            case .manageWebWallet:
                print(state.rawValue)
            case .activeWaiting:
                print(state.rawValue)
            case .paymentCanceledWithRetry:
                print(state.rawValue)
            case .paymentMethodsListShortcut:
                print(state.rawValue)
            case .paymentTransitionalShortcut:
                print(state.rawValue)
                
            default:
                break
            }
            
            break
        case .finalStateHasBeenReached(let state):
            switch state{
                
            case .paymentCanceled:
                print(state.rawValue)
            case .paymentSuccess:
                print(state.rawValue)
                delegate?.paymentControllerDidFinishPaymentForm(self)
                //      presentingViewController.dismiss(animated: true, completion: nil)
            case .paymentFailure:
                print(state.rawValue)
            case .tokenExpired:
                print(state.rawValue)
            case .browserNotSupported:
                print(state.rawValue)
            case .paymentOnHoldPartner:
                print(state.rawValue)
            case .paymentSuccessForceTicketDisplay:
                print(state.rawValue)
                
            default:
                break

            }
            
        }
        
    }
    
}
