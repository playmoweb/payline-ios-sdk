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
    var didGetContextInfoInt: ContextInfoResult? = nil
    var didGetContextInfoString: ContextInfoResult? = nil
    var didGetContextInfoObject: ContextInfoResult? = nil
    
    
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
        switch didGetContextInfo {
        case .int( _, _):
            self.didGetContextInfoInt = didGetContextInfo
        case .string(_,_):
            self.didGetContextInfoString = didGetContextInfo
        case .object(_, _):
            self.didGetContextInfoObject = didGetContextInfo
        }
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

//        it("getLanguage") {
//
//            let orderRef = UUID.init().uuidString
//            let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//            var tokenResponse: FetchTokenResponse? = nil
//
//            waitUntil(timeout: 5) { done in
//                TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                    tokenResponse = response
//                    done()
//                }
//            }
//
//            expect(tokenResponse).toNot(be(nil))
//            let url = URL(string: tokenResponse!.redirectUrl)
//            expect(url).toNot(be(nil))
//
//            paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//             expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//            paymentController.getLanguage()
//
//            expect(testDelegate.didGetLanguage).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//        }
//
//        describe("getContextInfo") {
//
//            it("amountSmallestUnit") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineAmountSmallestUnit)
//                expect(testDelegate.didGetContextInfoInt).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoInt = nil
//
//            }
//
//            it("currencyDigits") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineCurrencyDigits)
//                expect(testDelegate.didGetContextInfoInt).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoInt = nil
//
//            }
//
//            it("currencyCode") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineCurrencyCode)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoInt = nil
//
//            }
//
//            it("buyerFirstName") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerFirstName)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerLastName") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerLastName)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerShippingAddressStreet2") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressStreet2)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerShippingAddressStreet1") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressStreet1)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerShippingAddressCountry") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressCountry)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//            }
//
//            it("buyerShippingAddressName") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressName)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//            }
//
//            it("buyerShippingAddressCityName") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressCityName)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerShippingAddressZipCode") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressZipCode)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerShippingAddressPhone") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerShippingAddressPhone)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("buyerIp") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineBuyerIp)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("formattedAmount") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineFormattedAmount)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("orderDate") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDate)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("orderRef") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderRef)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("orderDeliveryMode") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDeliveryMode)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("deliveryTime") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//                testDelegate.didGetContextInfoString = nil
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDeliveryTime)
//                expect(testDelegate.didGetContextInfoString).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//
//            }
//
//            it("orderDetails") {
//
//                let orderRef = UUID.init().uuidString
//                let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR", languageCode: "FR")
//
//                var tokenResponse: FetchTokenResponse? = nil
//
//                waitUntil(timeout: 5) { done in
//                    TokenFetcher(path: "/init-web-pay", params: params).execute() { response in
//                        tokenResponse = response
//                        done()
//                    }
//                }
//
//                expect(tokenResponse).toNot(be(nil))
//                let url = URL(string: tokenResponse!.redirectUrl)
//                expect(url).toNot(be(nil))
//
//                paymentController.showPaymentForm(token: tokenResponse!.token, environment: url!)
//                expect(testDelegate.didShowPaymentForm).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
//
//                paymentController.getContextInfo(key: ContextInfoKeys.paylineOrderDetails)
//                expect(testDelegate.didGetContextInfoObject).toNotEventually(beNil(), timeout: 20, pollInterval: 1, description: nil)
//            }
//        }
    }
    
}
