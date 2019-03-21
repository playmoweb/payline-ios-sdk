//
//  ScriptEvent.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation

enum ScriptEvent: Equatable {
    
    case didShowState(WidgetState)
    case finalStateHasBeenReached(WidgetState)
    case didEndToken(WidgetState)
    
    enum Name: String, CaseIterable {
        case didShowState
        case finalStateHasBeenReached
        case didEndToken
    }
}
