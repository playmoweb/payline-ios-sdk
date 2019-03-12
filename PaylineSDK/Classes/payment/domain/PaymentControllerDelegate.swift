//
//  PaymentControllerDelegate.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation

public protocol PaymentControllerDelegate: class {
    
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController)
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState)
    
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool)
    func paymentController(_ paymentController: PaymentController, didGetLanguage: String)
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult)
}
 
