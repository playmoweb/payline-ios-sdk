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
    
    public func updateWebPaymentData(_ webPaymentData: String) {
        
    }
    
    public func getIsSandbox() {
        scriptHandler.execute(action: PaymentAction.isSandbox, in: webViewController.webView, callback: { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            guard let isSandbox = result as? Bool else { return }
            self?.delegate?.paymentController(strongSelf, didGetIsSandbox: isSandbox)
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
    
    public func getContextInfo(key: ContextInfoKeys) {
        scriptHandler.execute(action: PaymentAction.getContextInfo(key: key), in: webViewController.webView) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            switch key{
                
            case .paylineAmountSmallestUnit,
                 .paylineCurrencyDigits:
                guard let contextResult = result as? Int else { return }
                let contextInfoResult = ContextInfoResult.int(key, contextResult)
                debugPrint("test")
                strongSelf.delegate?.paymentController(strongSelf, didGetContextInfo: contextInfoResult)
                debugPrint("test2")
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
                let contextInfoResult = ContextInfoResult.object(key, contextResult)
                self?.delegate?.paymentController(strongSelf, didGetContextInfo: contextInfoResult)
            }

        }
        
    }
    
    // MARK: - Internal Interface
    
    weak var delegate: PaymentControllerDelegate?
    
    override func plWebViewControllerDidFinishLoadingWithSuccess(_ plWebViewController: PLWebViewController) {
      //  delegate?.paymentControllerDidShowPaymentForm(self)
    }
    
    override func handleReceivedEvent(_ event: ScriptEvent) {
        switch event {
        case .didShowState(let state):
            switch state {
            case .paymentMethodsList:
                delegate?.paymentControllerDidShowPaymentForm(self)
            case .paymentFailureWithRetry:
                 delegate?.paymentControllerDidShowPaymentForm(self)
            case .paymentMethodNeedsMoreInfo:
                 delegate?.paymentControllerDidShowPaymentForm(self)
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
            
        case .finalStateHasBeenReached(let state):
            switch state {
                
            case .paymentCanceled:
                delegate?.paymentControllerDidCancelPaymentForm(self)
            case .paymentSuccess:
                print(state.rawValue)
                delegate?.paymentControllerDidFinishPaymentForm(self)
            case .paymentFailure:
                print(state.rawValue)
                delegate?.paymentControllerDidFinishPaymentForm(self)
            case .tokenExpired:
                delegate?.paymentControllerDidFinishPaymentForm(self)
            case .browserNotSupported,
                 .paymentOnHoldPartner,
                 .paymentSuccessForceTicketDisplay:
                print(" ")
            default:
                break

            }
            
        }
    }
    
}
