//
//  WalletControllerTests.swift
//  PaylineSDK_Tests
//
//  Created by Rayan Mehdi on 08/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import TokenFetcher
@testable import PaylineSDK
import UIKit

class WalletTestDelegate: WalletControllerDelegate{
    
    var didShowWebWallet = false
    func walletControllerDidShowWebWallet(_ walletController: WalletController) {
        didShowWebWallet = true
    }
}

class WalletControllerTests: QuickSpec {
    
    func getWalletId() -> String {
        let defaults = UserDefaults.standard
        if let walletId = defaults.string(forKey: "WalletId"){
            return walletId
        }else{
            defaults.set(UUID.init().uuidString, forKey:"WalletId")
            return defaults.string(forKey: "WalletId")!
        }
    }
    
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
            
            let params = FetchWalletTokenParams.testWalletParams(walletId: self.getWalletId())

            waitUntil(timeout: 5) { done in
                TokenFetcher.execute(path: "/init-manage-wallet", params: params, callback: { [weak self] response in
                    tokenResponse = response
                    done()
                })
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
