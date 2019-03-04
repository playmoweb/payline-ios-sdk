//
//  ViewController.swift
//  PaylineSDK
//
//  Created by therealmyluckyday on 02/26/2019.
//  Copyright (c) 2019 therealmyluckyday. All rights reserved.
//

import UIKit
import PaylineSDK

struct FetchTokenParams: Encodable {
    let orderRef: String
    let amount: Int
    let currencyCode: String
    //    let buyer: Buyer
    //    let items: [CartItem]
}

struct Buyer: Encodable {
    let firstname: String
    let lastname: String
    let email: String
    let mobilePhone: String
    let shippingAddress: Address
    let walletId: String
}
//
struct Address: Encodable {
    let firstname: String
    let lastname: String
    let street1: String
    let street2: String
    let city: String
    let zipCode: Int
    let country: String
    let phone: String
}
//
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

//{
//    "code": "00000",
//    "message": "Transaction approved",
//    "redirectUrl": "https://homologation-webpayment.payline.com/v2/?token=18YkZVGoRGONz6uk32631550756437639",
//    "token": "18YkZVGoRGONz6uk32631550756437639"
//}

class ViewController: UIViewController {
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var walletButton: UIButton!
    
    
    private var testData: (String,URL)?
    private var walletData: (String,URL)?
    
    private lazy var paymentController: PaymentController = {
        return PaymentController(presentingViewController: self, delegate: self)
    }()
    
//    private lazy var walletController: WalletController = {
//        return WalletController(presentingViewController: self, delegate: self)
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.isEnabled = false
        walletButton.isEnabled = false
        
       
    }
    
    @IBAction func clickedPay(_ sender: Any?) {
        if let data = testData {
            paymentController.showPaymentForm(token: data.0, environment: data.1)
        }
    }
    
    @IBAction func clickedManageWallet(_ sender: Any?) {
        if let data = walletData{
            paymentController.showPaymentForm(token: data.0, environment: data.1)
        }
    }
    
    @IBAction func clickedGenerateToken(_ sender: Any) {
        let orderRef = UUID.init().uuidString
        let params = FetchTokenParams(orderRef: orderRef, amount: 5, currencyCode: "EUR")
        
        let url = URL(string: "https://demo-sdk-merchant-server.ext.dev.payline.com/init-web-pay")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(params)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data else {
                if let err = error {
                    debugPrint(err.localizedDescription)
                }
                return
            }
            
            if let json = try? JSONDecoder().decode(FetchTokenResponse.self, from: jsonData) {
                DispatchQueue.main.async { [weak self] in
                    self?.testData = (json.token, URL(string: json.redirectUrl)!)
                    self?.payButton.isEnabled = true
                }
            }
            }.resume()
        
//        let buyer = Buyer(firstname: "John.Doe@gmail.com", lastname: "John", email: "Doe", mobilePhone: "string", shippingAddress: Address(firstname: "John", lastname: "Doe", street1: "string", street2: "string", city: "Aix-en-Provence", zipCode: 13100, country: "FR", phone: "string"), walletId: "12342414-DFD-13434141")
//        
//        let walletUrl = URL(string: "https://demo-sdk-merchant-server.ext.dev.payline.com/init-manage-wallet")!
//        
//        
//        var walletRequest = URLRequest(url: walletUrl)
//        walletRequest.httpMethod = "POST"
//        walletRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        walletRequest.httpBody = try? JSONEncoder().encode(buyer)
//        
//        URLSession.shared.dataTask(with: walletRequest) { (data, response, error) in
//            guard let jsonData = data else {
//                if let err = error {
//                    debugPrint(err.localizedDescription)
//                }
//                return
//            }
//            
//            if let json = try? JSONDecoder().decode(FetchTokenResponse.self, from: jsonData) {
//                DispatchQueue.main.async { [weak self] in
//                    self?.walletData = (json.token, URL(string: json.redirectUrl)!)
//                    self?.walletButton.isEnabled = true
//                }
//            }
//            }.resume()
    }
    
    
}

extension ViewController: PaymentControllerDelegate {
    
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        self.paymentController.getLanguage()
        self.paymentController.getIsSandbox()
        self.paymentController.getContextInfo(key: ContextInfoKeys.paylineCurrencyDigits)
        self.paymentController.getContextInfo(key: ContextInfoKeys.paylineCurrencyCode)
    }
    
    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController) {
        debugPrint("cancel")
        self.paymentController.doEndToken(additionalData: nil, isHandledByMerchant: true)
    }
    
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {
        print(didGetIsSandbox)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {
        debugPrint(didGetLanguage)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {
        print("DIDGETINFOCONTEXT")
        print(didGetContextInfo)
    }
    
}

//extension ViewController: WalletControllerDelegate {
//    
//    func walletControllerDidFinishManagingWebWallet(_ walletController: WalletController) {
//        //
//    }
//    
//}
