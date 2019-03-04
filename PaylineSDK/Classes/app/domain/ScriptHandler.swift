//
//  ScriptHandler.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation
import WebKit

struct ScriptHandler {
    
    typealias EventCallback = (ScriptEvent) -> Void
    typealias ActionCallback = (Any?, Error?) -> Void
    
    let handledEvents = ScriptEvent.Name.allCases
    
    func handle(message: WKScriptMessage, callback: EventCallback) {
        
        guard let eventName = ScriptEvent.Name(rawValue: message.name) else { return }
        
        switch eventName {
        case .didShowState:
            guard let eventBody = message.body as? [String: String] else { return }
            guard let event = eventBody["state"] else { return }
            guard let state = WidgetState(rawValue: event) else { return }
            callback(ScriptEvent.didShowState(state))
        case .finalStateHasBeenReached:
            guard let eventBody = message.body as? [String: String] else { return }
            guard let event = eventBody["state"] else { return }
            guard let state = WidgetState(rawValue: event) else { return }
            callback(ScriptEvent.finalStateHasBeenReached(state))
        case .didEndToken:
            callback(ScriptEvent.didEndToken)
        }
    }
    
    func execute(action: ScriptAction, in webView: WKWebView, callback: ActionCallback?) {
        webView.evaluateJavaScript(action.command, completionHandler: callback)
    }
}
