//
//  ScriptHandler.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation
import WebKit

struct ScriptHandler {
    
    typealias EventCallback = (ScriptEvent)->Void
    typealias ActionCallback = (Any?,Error?)->Void
    
    let handledEvents = ScriptEvent.Name.allCases
    
    func handle(message: WKScriptMessage, callback: EventCallback) {
        
        guard let eventName = ScriptEvent.Name(rawValue: message.name) else { return }
        
        // TODO: parse eventBody to WidgetState
        guard let eventBody = message.body as? NSDictionary else { return }
        let test = WidgetState.paymentMethodsList
        
        switch eventName {
        case .didShowState:
            // TODO: extract values?
            callback(ScriptEvent.didShowState(test))
        case .finalStateHasBeenReached:
            callback(ScriptEvent.finalStateHasBeenReached(test))
        }
    }
    
    func execute(action: ScriptAction, in webView: WKWebView, callback: ActionCallback?) {
        webView.evaluateJavaScript(action.command, completionHandler: callback)
    }
}
