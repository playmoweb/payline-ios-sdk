//
//  PaymentControllerTests.swift
//  PaylineSDK_Tests
//
//  Created by MacBook on 3/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import PaylineSDK
import UIKit

class TestDelegate: PaymentControllerDelegate {
    
    var didShowPaymentForm = false
    var didCancelPaymentForm = false
    var didFinishPaymentForm = false
    var didGetSandbox: Bool? = nil
    var didGetContextInfo: ContextInfoResult? = nil
    
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        didShowPaymentForm = true
    }
    
    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController) {
        didCancelPaymentForm = true
    }
    
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController) {
        didFinishPaymentForm = true
    }
    
//    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {}
//    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {}
//    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {}
}

class PaymentControllerTests: QuickSpec {
    
    override func spec() {
        
        var viewController: UIViewController!
        var paymentController: PaymentController!
        var testDelegate: TestDelegate!
        
        beforeEach {
            viewController = UIViewController()
            testDelegate = TestDelegate()
            paymentController = PaymentController(presentingViewController: viewController, delegate: testDelegate)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController = viewController
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
        }
           
        it("showPaymentForm") {
            
            let orderRef = UUID.init().uuidString
            let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
            
            var tokenResponse: FetchTokenResponse? = nil
            
            waitUntil(timeout: 5) { done in
                TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
                    tokenResponse = response
                    done()
                }
            }
            
            expect(tokenResponse).toNot(be(nil))
            let url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
            
            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
            
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
    }
    
}
