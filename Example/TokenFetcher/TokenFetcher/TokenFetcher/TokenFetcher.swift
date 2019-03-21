//
//  TokenFetcher.swift
//  TokenFetcher
//
//  Created by Rayan Mehdi on 18/03/2019.
//  Copyright © 2019 Payline. All rights reserved.
//

import Foundation

public class TokenFetcher {
    
    let path: String
    let params: Encodable
    
    init(path: String, params: Encodable) {
        self.path = path
        self.params = params
    }
    
    public class func execute(path: String, params: Encodable, callback: @escaping (FetchTokenResponse) -> Void) {
        
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
