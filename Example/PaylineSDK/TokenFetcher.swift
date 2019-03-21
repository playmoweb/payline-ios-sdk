////
////  TokenFetcher.swift
////  PaylineSDK_Example
////
////  Created by MacBook on 3/5/19.
////  Copyright © 2019 CocoaPods. All rights reserved.
////
//
//import Foundation
//
//struct TokenFetcher {
//
//    let path: String
//    let params: Encodable
//
//    func execute(callback: @escaping (FetchTokenResponse) -> Void) {
//
//        var comps = URLComponents()
//        comps.scheme = "https"
//        comps.host = "demo-sdk-merchant-server.ext.dev.payline.com"
//        comps.path = path
//        let url = comps.url!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = params.jsonData()!
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            guard let jsonData = data else {
//                if let err = error {
//                    debugPrint(err.localizedDescription)
//                }
//                return
//            }
//
//            if let response = try? JSONDecoder().decode(FetchTokenResponse.self, from: jsonData) {
//                DispatchQueue.main.async {
//                    callback(response)
//                }
//            }
//        }.resume()
//    }
//}
//
//extension Encodable {
//    func jsonData(using encoder: JSONEncoder = JSONEncoder()) -> Data? {
//        return try? encoder.encode(self)
//    }
//}
