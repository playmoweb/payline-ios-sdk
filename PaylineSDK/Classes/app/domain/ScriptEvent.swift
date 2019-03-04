//
//  ScriptEvent.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation

enum ScriptEvent {
    
    case didShowState(WidgetState)
    case finalStateHasBeenReached(WidgetState)
    case didEndToken
    
    enum Name: String, CaseIterable {
        case didShowState
        case finalStateHasBeenReached
        case didEndToken
    }
}
