//
//  WalletControllerTests.swift
//  PaylineSDK_Tests
//
//  Created by Rayan Mehdi on 08/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import PaylineSDK
import UIKit

class WalletTestDelegate: WalletControllerDelegate{
    
    var didShowWebWallet = false
    func walletControllerDidShowWebWebWallet(_ walletController: WalletController) {
        didShowWebWallet = true
    }
}

class WalletControllerTests: QuickSpec {
    
    override func spec() {
        
        var viewController: UIViewController!
        var walletController: WalletController!
        var walletTestDelegate: WalletTestDelegate!
        var tokenResponse: FetchTokenResponse? = nil
        var url: URL? = nil
        
        beforeEach {
            
            viewController = UIViewController()
            walletTestDelegate = WalletTestDelegate()
            walletController = WalletController(presentingViewController: viewController, delegate: walletTestDelegate)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController = viewController
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            
            let params = FetchWalletTokenParams(
                buyer: Buyer(
                    firstname: "John",
                    lastname: "Doe",
                    email: "John.Doe@gmail.com",
                    mobilePhone: "0123456789",
                    shippingAddress: Address(
                        firstname: "John",
                        lastname: "Doe",
                        street1: "1 rue de Rue",
                        city: "Aix-en-Provence",
                        zipCode: 13100,
                        country: "FR",
                        phone: "0123456789"
                    ),
                    walletId: "12342414-DFD-13434141"
                ),
                updatePersonalDetails: false,
                languageCode: "EN"
            )

            waitUntil(timeout: 5) { done in
                TokenFetcher(path: "/init-manage-wallet", params: params).execute() { [weak self] response in
                    tokenResponse = response
                    done()
                }
            }
            
            expect(tokenResponse).toNot(be(nil))
            url = URL(string: tokenResponse!.redirectUrl)
            expect(url).toNot(be(nil))
        }
        
        it("didShowWebWallet"){
            walletController.manageWebWallet(environment: url!)
            expect(walletTestDelegate.didShowWebWallet).toEventually(beTruthy(), timeout: 20, pollInterval: 1, description: nil)
        }
    }
}
