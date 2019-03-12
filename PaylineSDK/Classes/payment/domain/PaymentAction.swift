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
    case endToken(additionalData: Encodable?, isHandledByMerchant: Bool)
    case getLanguage
    case getContextInfo(key: ContextInfoKey)
    
    var command: String {
        
        let com: String
        
        switch self {
        case .updateWebPaymentData(let data):
            com = "updateWebPaymentData(\(data))"
        case .isSandbox:
            com = "isSandbox()"
        case let .endToken(additionalData, isHandledByMerchant):
            let parsed = additionalData?.jsonString() ?? "null"
            com = "endToken(\(parsed), function() { window.webkit.messageHandlers.didEndToken.postMessage(''); }, null, \(isHandledByMerchant.description))"
        case .getLanguage:
            com = "getLanguage()"
        case .getContextInfo(let key):
            com = "getContextInfo('\(key.rawValue)')"
        }
        
        return "Payline.Api.\(com);"
    }
    
}

internal extension Encodable {
    
    func jsonData(using encoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? encoder.encode(self)
    }
    
    func jsonString(using encoder: JSONEncoder = JSONEncoder()) -> String? {
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
}
