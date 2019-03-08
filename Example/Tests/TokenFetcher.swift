//
//  TokenFetcher.swift
//  PaylineSDK_Tests
//
//  Created by MacBook on 3/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct Buyer: Encodable {
    let firstname: String
    let lastname: String
    let email: String
    let mobilePhone: String
    let shippingAddress: Address
    let walletId: String
}

struct Address: Encodable {
    let firstname: String
    let lastname: String
    let street1: String
    //    let street2: String
    let city: String
    let zipCode: Int
    let country: String
    let phone: String
}
protocol FetchTokenParams: Encodable {}

struct FetchWalletTokenParams: FetchTokenParams {
    let buyer: Buyer
    let updatePersonalDetails: Bool
    let languageCode: String
}

struct FetchPaymentTokenParams: FetchTokenParams {
    let orderRef: String
    let amount: Double
    let currencyCode: String
    let languageCode: String
    //    let buyer: Buyer
    //    let items: [CartItem]
}

struct FetchTokenResponse: Decodable {
    let code: String
    let message: String
    let redirectUrl: String
    let token: String
}

struct TokenFetcher {
    
    let path: String
    let params: Encodable
    
    func execute(callback: @escaping (FetchTokenResponse) -> Void) {
        
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = "demo-sdk-merchant-server.ext.dev.payline.com"
        comps.path = path
        let url = comps.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.jsonData()!
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let jsonData = data else {
                if let err = error {
                    debugPrint(err.localizedDescription)
                }
                return
            }
            
            if let response = try? JSONDecoder().decode(FetchTokenResponse.self, from: jsonData) {
                DispatchQueue.main.async {
                    callback(response)
                }
            }
            }.resume()
    }
}

extension Encodable {
    func jsonData(using encoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? encoder.encode(self)
    }
}
