//
//  PaymentControllerDelegate.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation

public protocol PaymentControllerDelegate: class {
    // NOTE: required interface
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController)
    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController)
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController)
    // TODO: do we need didEndToken separately from DidFinishPaymentForm?
}
extension PaymentControllerDelegate {
    // NOTE: optional interface
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {}
    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {}
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: String) {}
}
