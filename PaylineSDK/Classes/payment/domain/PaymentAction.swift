//
//  PaymentAction.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation
import WebKit

enum PaymentAction: ScriptAction {
    
    case updateWebPaymentData(data: String)
    case isSandbox
    case endToken
    case getLanguage
    case getContextInfo(key: String)
    case finalizeShortCut
    case getBuyerShortCut
    
    var command: String {
        
        let c: String
        
        switch self {
        case .updateWebPaymentData(let data):
            c = "updateWebPaymentData(\(data))"
        case .isSandbox:
            c = "isSandbox()"
        case .endToken:
            c = "endToken()"
        case .getLanguage:
            c = "getLanguage()"
        case .getContextInfo(let key):
            c = "getContextInfo(\(key))"
        case .finalizeShortCut:
            c = "finalizeShortCut()"
        case .getBuyerShortCut:
            c = "getBuyerShortCut()"
        }
        
        return "Payline.Api.\(c);"
    }
    
}
