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
        scriptHandler.execute(action: PaymentAction.updateWebPaymentData(data: webPaymentData), in: webViewController.webView, callback: nil)
    }
    
    public func getIsSandbox() {
        scriptHandler.execute(action: PaymentAction.isSandbox, in: webViewController.webView, callback: { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            guard let isSandbox = result as? Bool else { return }
            self?.delegate?.paymentController(strongSelf, didGetIsSandbox: isSandbox)
        })
    }
    
    public func endToken(additionalData: Encodable?, isHandledByMerchant: Bool) {
        scriptHandler.execute(action: PaymentAction.endToken(additionalData: additionalData, isHandledByMerchant: isHandledByMerchant), in: webViewController.webView, callback: nil)
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
    
    override func plWebViewControllerDidRequestClose(_ plWebViewController: PLWebViewController) {
        self.endToken(additionalData: nil, isHandledByMerchant: true)
    }
    
    override func handleReceivedEvent(_ event: ScriptEvent) {
        switch event {
            
        case .didShowState(let state):
            handleDidShowState(state: state)
            
        case .finalStateHasBeenReached(let state):
            handleFinalStateHasBeenReached(state: state)
            
        case .didEndToken:
            cancelPayment()
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
            finishPayment()
            self.webViewController.closeButton?.isHidden = false
    }
    
    private func cancelPayment() {
        delegate?.paymentControllerDidCancelPaymentForm(self)
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    private func finishPayment() {
        delegate?.paymentControllerDidFinishPaymentForm(self)
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
