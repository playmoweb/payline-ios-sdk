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
    var didGetLanguage: String? = nil
    var didGetContextInfo = false
    
    
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        didShowPaymentForm = true
    }
    
    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController) {
        didCancelPaymentForm = true
    }
    
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController) {
        didFinishPaymentForm = true
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
            
            let orderRef = UUID.init().uuidString
            params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
            
            waitUntil(timeout: 5) { done in
                TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
                    tokenResponse = response
                    done()
                }
            }
            
            expect(tokenResponse).toNot(be(nil))
            url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
        }
           
        it("showPaymentForm") {
            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }

        it("cancelPaymentForm") {
            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            paymentController.webViewController.closeButton?.sendActions(for: .touchUpInside)
            expect(testDelegate.didCancelPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
        
        it("finishPaymentForm_success") {
            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
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
            let orderRef = UUID.init().uuidString
            params = FetchPaymentTokenParams(orderRef: orderRef, amount: 33312, currencyCode: "EUR", languageCode: "FR")
            
            waitUntil(timeout: 5) { done in
                TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
                    tokenResponse = response
                    done()
                }
            }
            
            expect(tokenResponse).toNot(be(nil))
            url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
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
        
        it("endToken") {
            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            paymentController.endToken(additionalData: nil, isHandledByMerchant: true)
            expect(testDelegate.didCancelPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }

        it("isSandbox") {

            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
            expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            paymentController.getIsSandbox()
            expect(testDelegate.didGetSandbox).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
        }

        it("getLanguage") {

            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
             expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            paymentController.getLanguage()

            expect(testDelegate.didGetLanguage).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
        }
//
        describe("getContextInfo") {
//
            it("amountSmallestUnit") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKeys.paylineAmountSmallestUnit)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                

            }
//
            it("currencyDigits") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKeys.paylineCurrencyDigits)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
//
            it("currencyCode") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKeys.paylineCurrencyCode)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }
//
            it("buyerFirstName") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerFirstName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerLastName") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerLastName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressStreet2") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressStreet2)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressStreet1") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressStreet1)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerShippingAddressCountry") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressCountry)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressName") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }

            it("buyerShippingAddressCityName") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressCityName)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerShippingAddressZipCode") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressZipCode)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerShippingAddressPhone") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressPhone)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }

            it("buyerIp") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerIp)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }
//
            it("formattedAmount") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineFormattedAmount)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
//
            it("orderDate") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDate)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
//
            it("orderRef") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderRef)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
//
            it("orderDeliveryMode") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDeliveryMode)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
//
            it("deliveryTime") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDeliveryTime)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

            }
//
            it("orderDetails") {

                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)

                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDetails)
                expect(testDelegate.didGetContextInfo).toNotEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
            }
        }
    }
    
}
