//
//  FetchTokenResponse.swift
//  TokenFetcher
//
//  Created by Rayan Mehdi on 18/03/2019.
//  Copyright © 2019 Payline. All rights reserved.
//

import Foundation

public struct FetchTokenResponse: Decodable {
   public let code: String
   public let message: String
   public let redirectUrl: String
   public let token: String
}
