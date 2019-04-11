//
//  ViewController.swift
//  PaylineSDK
//
//  Created by therealmyluckyday on 02/26/2019.
//  Copyright (c) 2019 therealmyluckyday. All rights reserved.
//

import UIKit
import PaylineSDK
import TokenFetcher

class ViewController: UIViewController {
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var amoutTextField: UITextField!
    
    var testData: (URL)?
    var walletData: (URL)?
    
    lazy var paymentController: PaymentController = {
        return PaymentController(presentingViewController: self, delegate: self)
    }()
    
    lazy var walletController: WalletController = {
        return WalletController(presentingViewController: self, delegate: self)
    }()
    
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.isEnabled = false
        walletButton.isEnabled = false
    }
    
    func getWalletId() -> String {
        let defaults = UserDefaults.standard
        if let walletId = defaults.string(forKey: "WalletId"){
            return walletId
        }else{
            defaults.set(UUID.init().uuidString, forKey:"WalletId")
            return defaults.string(forKey: "WalletId")!
        }
    }
    
    @IBAction func clickedGeneratePaymentToken(_ sender: Any?) {
        self.payButton.isEnabled = false
        let walletId = getWalletId()
        let params = FetchPaymentTokenParams.testPaymentParams(amout: Double(amoutTextField.text!) ?? 5, walletId: walletId )

        TokenFetcher.execute(path: "/init-web-pay", params: params, callback: { [weak self] response in
            self?.testData = URL(string: response.redirectUrl )!
            self?.payButton.isEnabled = true
        })
    }
    
    @IBAction func clickedGenerateWalletToken(_ sender: Any) {
        let walletId = getWalletId()
        let params = FetchWalletTokenParams.testWalletParams(walletId: walletId)
        
        TokenFetcher.execute(path: "/init-manage-wallet", params: params, callback: { [weak self] response in
            self?.walletData = (URL(string: response.redirectUrl )!)
            self?.walletButton.isEnabled = true
        })

    }
    
    @IBAction func clickedPay(_ sender: Any?) {
        payButton.isEnabled = false
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
        self.paymentController.getLanguageCode()
        self.paymentController.getIsSandbox()
        self.paymentController.getContextInfo(key: ContextInfoKey.paylineCurrencyDigits)
        self.paymentController.getContextInfo(key: ContextInfoKey.paylineCurrencyCode)
    }
    
    
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState) {
        alert = UIAlertController(title: "Alert", message: state.rawValue, preferredStyle: .alert)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.showAlertDialog), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(ViewController.dismissAlert), userInfo: nil, repeats: false)
       
        debugPrint("didFinish")
    }
    
    
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {
        debugPrint(didGetIsSandbox)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetLanguageCode didGetLanguageCode: String) {
        debugPrint(didGetLanguageCode)
    }
    
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {
        print(didGetContextInfo)
    }
    
    @objc func showAlertDialog(){
        self.present(alert, animated: true, completion: nil)
    }
    
     @objc func dismissAlert(){
        alert.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: WalletControllerDelegate {
    func walletControllerDidShowWebWallet(_ walletController: WalletController) {
        debugPrint("didShowManageWallet")
    }
    

}
