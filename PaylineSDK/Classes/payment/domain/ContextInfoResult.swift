//
//  ContextInfoResult.swift
//  PaylineSDK
//
//  Created by Rayan Mehdi on 01/03/2019.
//

import Foundation
/**
 * Cette enum va être utilisée pour traiter le résultat obtenu par la wevView
 * Trois types de données pourront être reçus : Int, String, [[String : Any]]
 *
 * [PW-API JavaScript](https://payline.atlassian.net/wiki/spaces/DT/pages/1329037328/PW+-+API+JavaScript)
 */
public enum ContextInfoResult {
    ///Traite un résultat de type Int reçu par la webView
    /// - Params:
    ///   - ContextInfoKeys: Correspond à la clé de l'information que l'on obtient
    ///   - Int: Correspond à l'information de type Int que l'on reçoit
    case int(ContextInfoKeys, Int)
    ///Traite un résultat de type String reçu par la webView
    /// - Params:
    ///   - ContextInfoKeys: Correspond à la clé de l'information que l'on obtient
    ///   - String: Correspond à l'information de type String que l'on reçoit
    case string(ContextInfoKeys, String)
    ///Traite un résultat de type [[String : Any]] reçu par la webView
    /// - Params:
    ///   - ContextInfoKeys: Correspond à la clé de l'information que l'on obtient
    ///   - [[String:Any]]: Correspond à l'information de type [[String : Any]] que l'on reçoit
    case object(ContextInfoKeys, [[String: Any]])
}
