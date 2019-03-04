//
//  ContextInfoResult.swift
//  PaylineSDK
//
//  Created by Rayan Mehdi on 01/03/2019.
//

import Foundation

enum ContextInfoResult {
    case int(ContextInfoKeys, Int)
    case string(ContextInfoKeys, String)
    case object(ContextInfoKeys, [[String:String]])
}
