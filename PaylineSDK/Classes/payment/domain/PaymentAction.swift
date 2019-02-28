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
        
        let com: String
        
        switch self {
        case .updateWebPaymentData(let data):
            com = "updateWebPaymentData(\(data))"
        case .isSandbox:
            com = "isSandbox()"
        case .endToken:
            com = "endToken()"
        case .getLanguage:
            com = "getLanguage()"
        case .getContextInfo(let key):
            com = "getContextInfo(\(key))"
        case .finalizeShortCut:
            com = "finalizeShortCut()"
        case .getBuyerShortCut:
            com = "getBuyerShortCut()"
        }
        
        return "Payline.Api.\(com);"
    }
    
}
