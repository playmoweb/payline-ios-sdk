//
//  WidgetState.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation

/**
 These are possible values for the "Payline JS Widget" state and is transmitted by the widget's callback mechanisms.
 It is used by the SDK to determine certain callback possibilities
 */
enum WidgetState: String {
    case paymentMethodsList = "PAYMENT_METHODS_LIST"
    case paymentCanceled = "PAYMENT_CANCELED"
    case paymentSuccess = "PAYMENT_SUCCESS"
    case paymentFailure = "PAYMENT_FAILURE"
    case paymentFailureWithRetry = "PAYMENT_FAILURE_WITH_RETRY"
    case tokenExpired = "TOKEN_EXPIRED"
    case browserNotSupported = "BROWSER_NOT_SUPPORTED"
    case paymentMethodNeedsMoreInfo = "PAYMENT_METHOD_NEEDS_MORE_INFOS"
    case paymentRedirectNoResponse = "PAYMENT_REDIRECT_NO_RESPONSE"
    case manageWebWallet = "MANAGED_WEB_WALLET"
    case activeWaiting = "ACTIVE_WAITING"
    case paymentCanceledWithRetry = "PAYMENT_CANCELED_WITH_RETRY"
    case paymentOnHoldPartner = "PAYMENT_ONHOLD_PARTNER"
    case paymentSuccessForceTicketDisplay = "PAYMENT_SUCCESS_FORCE_TICKET_DISPLAY"
//    case paymentMethodsListShortcut = "PAYMENT_METHODS_LIST_SHORTCUT"
//    case paymentTransitionalShortcut = "PAYMENT_TRANSITIONAL_SHORTCUT"
}
extension WidgetState: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
 
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .paymentMethodsList:
            try container.encode(0, forKey: .rawValue)
        case .paymentCanceled:
            try container.encode(1, forKey: .rawValue)
        case .paymentSuccess:
            try container.encode(2, forKey: .rawValue)
        case .paymentFailure:
            try container.encode(3, forKey: .rawValue)
        case .paymentFailureWithRetry:
            try container.encode(4, forKey: .rawValue)
        case .tokenExpired:
            try container.encode(5, forKey: .rawValue)
        case .browserNotSupported:
            try container.encode(6, forKey: .rawValue)
        case .paymentMethodNeedsMoreInfo:
            try container.encode(7, forKey: .rawValue)
        case .paymentRedirectNoResponse:
            try container.encode(8, forKey: .rawValue)
        case .manageWebWallet:
            try container.encode(9, forKey: .rawValue)
        case .activeWaiting:
            try container.encode(10, forKey: .rawValue)
        case .paymentCanceledWithRetry:
            try container.encode(11, forKey: .rawValue)
        case .paymentOnHoldPartner:
            try container.encode(12, forKey: .rawValue)
        case .paymentSuccessForceTicketDisplay:
            try container.encode(13, forKey: .rawValue)
//        case .paymentMethodsListShortcut:
//            try container.encode(14, forKey: .rawValue)
//        case .paymentTransitionalShortcut:
//            try container.encode(15, forKey: .rawValue)

        }
    }
}
