//
//  ViewController.swift
//  PaylineSDK
//
//  Created by therealmyluckyday on 02/26/2019.
//  Copyright (c) 2019 therealmyluckyday. All rights reserved.
//

import UIKit
import PaylineSDK

protocol FetchTokenParams: Encodable {}

struct FetchPaymentTokenParams: FetchTokenParams {
    let orderRef: String
    let amount: Double
    let currencyCode: String
    let languageCode: String
//    let buyer: Buyer
//    let items: [CartItem]
}

struct FetchWalletTokenParams: FetchTokenParams {
    let buyer: Buyer
    let updatePersonalDetails: Bool
    let languageCode: String
}

struct Buyer: Encodable {
    let firstname: String
    let lastname: String
    let email: String
    let mobilePhone: String
    let shippingAddress: Address
    let walletId: String
}

struct Address: Encodable {
    let firstname: String
    let lastname: String
    let street1: String
//    let street2: String
    let city: String
    let zipCode: Int
    let country: String
    let phone: String
}

//struct CartItem: Encodable {
//    let ref: String
//    let price: Int
//    let quantity: Int
//    let brand: String
//    let category: String
//}

//curl https://demo-sdk-merchant-server.ext.dev.payline.com/init-web-pay \
//    -H "Content-Type:application/json" \
//    -X POST \
//    --data '{"orderRef": "00001", "amount":987, "currencyCode":"EUR","buyer": {"firstname": "John", "lastname": "Doe", "email": "john.doe@gmail.com", "mobilePhone":"0612345678", "shippingAddress": {"firstname":"Jane", "lastname":"Smith", "street1": "S1", "street2": "S2", "city":"Aix-en-Provence", "zipCode":"13100", "country":"France", "phone": "0412341234"}}, "items":[{"ref": "i1"}, {"ref": "i2", "price": 15, "quantity": 3, "brand":"Nike", "category":"Shoes"}]}'

struct FetchTokenResponse: Decodable {
    let code: String
    let message: String
    let redirectUrl: String
    let token: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    
    var testData: (URL)?
    var walletData: (URL)?
    
    lazy var paymentController: PaymentController = {
        return PaymentController(presentingViewController: self, delegate: self)
    }()
    
    lazy var walletController: WalletController = {
        return WalletController(presentingViewController: self, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.isEnabled = false
        walletButton.isEnabled = false
    }
    
    @IBAction func clickedGeneratePaymentToken(_ sender: Any?) {
        
        let orderRef = UUID.init().uuidString
        let params = FetchPaymentTokenParams(orderRef: orderRef, amount: 5 , currencyCode: "EUR", languageCode: "FR")
        
        TokenFetcher(path: "/init-web-pay", params: params).execute() { [weak self] response in
            self?.testData = (URL(string: response.redirectUrl)!)
            self?.payButton.isEnabled = true
        }
    }
    
    @IBAction func clickedGenerateWalletToken(_ sender: Any) {
        
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
        
        TokenFetcher(path: "/init-manage-wallet", params: params).execute() { [weak self] response in
            self?.walletData = (URL(string: response.redirectUrl)!)
            self?.walletButton.isEnabled = true
        }
    }
    
    @IBAction func clickedPay(_ sender: Any?) {
        if let data = testData {
            paymentController.showPaymentForm(environment: data)
        }
    }
    
    @IBAction func clickedManageWallet(_ sender: Any?) {
        if let data = walletData {
            walletController.manageWebWallet(environment: data)
        }
    }
    
}

extension ViewController: PaymentControllerDelegate {
    
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        self.paymentController.getLanguage()
        self.paymentController.getIsSandbox()
        self.paymentController.getContextInfo(key: ContextInfoKey.paylineCurrencyDigits)
        self.paymentController.getContextInfo(key: ContextInfoKey.paylineCurrencyCode)
    }
    
    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController) {
        debugPrint("didCancel")
    }
    
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState) {
        debugPrint("didFinish")
    }
    
    
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {
        debugPrint(didGetIsSandbox)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {
        debugPrint(didGetLanguage)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {
        print(didGetContextInfo)
    }
    
}

extension ViewController: WalletControllerDelegate {
    func walletControllerDidShowWebWebWallet(_ walletController: WalletController) {
        debugPrint("didShowManageWallet")
    }
    

}
