//
//  PaymentControllerTests.swift
//  PaylineSDK_Tests
//
//  Created by MacBook on 3/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import TokenFetcher
@testable import PaylineSDK
import UIKit

class TestDelegate: PaymentControllerDelegate {
    
    
    var didShowPaymentForm = false
    var didCancelPaymentForm = false
    var didFinishPaymentForm = false
    var didGetSandbox: Bool? = nil
    var didGetLanguage: String? = nil
    var didGetContextInfo = false
    
    
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        didShowPaymentForm = true
    }
    
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState) {
        if state == .paymentCanceled{
            didCancelPaymentForm = true
        } else {
            didFinishPaymentForm = true
        }
    }
    
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {
        self.didGetSandbox = didGetIsSandbox
    }
    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {
        self.didGetLanguage = didGetLanguage
    }
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {
        self.didGetContextInfo = true
    }
}

class PaymentControllerTests: QuickSpec {
    
    override func spec() {
        
        var viewController: UIViewController!
        var paymentController: PaymentController!
        var testDelegate: TestDelegate!
        var params: FetchPaymentTokenParams!
        var tokenResponse: FetchTokenResponse? = nil
        var url: URL? = nil
        
        beforeEach {
            
            viewController = UIViewController()
            testDelegate = TestDelegate()
            paymentController = PaymentController(presentingViewController: viewController, delegate: testDelegate)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController = viewController
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            
            params = FetchPaymentTokenParams.testPaymentParams(amout: 5)
     
            waitUntil(timeout: 5) { done in
                TokenFetcher.execute(path: "/init-web-pay", params: params, callback: { [weak self] response in
                    tokenResponse = response
                    done()
                })
            }
            
            expect(tokenResponse).toNot(be(nil))
            url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
        }
           
        it("showPaymentForm") {
            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }

        it("buttonClickCancel") {
            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            paymentController.webViewController.closeButton?.sendActions(for: .touchUpInside)
            expect(testDelegate.didCancelPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
        
        it("finishPaymentForm_success") {
            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            
            paymentController.plWebViewController(
                paymentController.webViewController,
                didReceive: TestScriptMessage(
                    name: "finalStateHasBeenReached",
                    body: ["state":WidgetState.paymentSuccess.rawValue]
                )
            )
            expect(testDelegate.didFinishPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
        
        it("finishPaymentForm_failure") {
            let params = FetchPaymentTokenParams.testPaymentFailureParams()
            
            waitUntil(timeout: 5) { done in
                TokenFetcher.execute(path: "/init-web-pay", params: params, callback: { [weak self] response in
                    tokenResponse = response
                    done()
                })
            }
            
            expect(tokenResponse).toNot(be(nil))
            url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            
            paymentController.plWebViewController(
                paymentController.webViewController,
                didReceive: TestScriptMessage(
                    name: "finalStateHasBeenReached",
                    body: ["state":WidgetState.paymentFailure.rawValue]
                )
            )
            expect(testDelegate.didFinishPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
        
        it("finishPaymentForm_cancelled") {
            let params = FetchPaymentTokenParams.testPaymentParams(amout: 5)
            
            waitUntil(timeout: 5) { done in
                TokenFetcher.execute(path: "/init-web-pay", params: params, callback: { [weak self] response in
                    tokenResponse = response
                    done()
                })
            }
            
            expect(tokenResponse).toNot(be(nil))
            url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            
            paymentController.plWebViewController(
                paymentController.webViewController,
                didReceive: TestScriptMessage(
                    name: "finalStateHasBeenReached",
                    body: ["state":WidgetState.paymentCanceled.rawValue]
                )
            )
            expect(testDelegate.didCancelPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
        
        it("endToken") {
            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            paymentController.endToken(additionalData: nil, isHandledByMerchant: true)
            expect(testDelegate.didCancelPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }

        it("isSandbox") {

            paymentController.showPaymentForm(environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            paymentController.getIsSandbox()
            expect(testDelegate.didGetSandbox).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
        }

        it("getLanguage") {

            paymentController.showPaymentForm(environment: url!)
             expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            paymentController.getLanguage()

            expect(testDelegate.didGetLanguage).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
        }

        describe("getContextInfo") {

            it("amountSmallestUnit") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKey.paylineAmountSmallestUnit)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                

            }

            it("currencyDigits") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKey.paylineCurrencyDigits)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("currencyCode") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKey.paylineCurrencyCode)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerFirstName") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerFirstName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerLastName") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerLastName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressStreet2") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressStreet2)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressStreet1") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressStreet1)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerShippingAddressCountry") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressCountry)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressName") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressCityName") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressCityName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerShippingAddressZipCode") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressZipCode)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerShippingAddressPhone") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerShippingAddressPhone)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerIp") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKey.paylineBuyerIp)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("formattedAmount") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineFormattedAmount)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("orderDate") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineOrderDate)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("orderRef") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineOrderRef)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("orderDeliveryMode") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineOrderDeliveryMode)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("deliveryTime") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKey.paylineOrderDeliveryTime)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("orderDetails") {

                paymentController.showPaymentForm(environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKey.paylineOrderDetails)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
        }
    }
    
}
