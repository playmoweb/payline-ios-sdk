//
//  FetchTokenParams.swift
//  TokenFetcher
//
//  Created by Rayan Mehdi on 18/03/2019.
//  Copyright © 2019 Payline. All rights reserved.
//

import Foundation



public protocol FetchTokenParams: Encodable {}

public struct FetchPaymentTokenParams: FetchTokenParams {
    let orderRef: String
    let amount: Double
    let currencyCode: String
    let languageCode: String
    let buyer: Buyer
    let customPaymentPageCode: String
    
    public static func testPaymentParams(amout: Double, walletId: String) -> FetchPaymentTokenParams {
        let orderRef = UUID.init().uuidString
        let buyer = Buyer(
        firstname: "John",
        lastname: "Doe",
        email: "John.Doe@gmail.com",
        mobilePhone: "0123456789",
        shippingAddress: Address(
        firstname: "John",
        lastname: "Doe",
        street1: "1 rue de Rue",
        city: "Aix-en-Provence",
        zipCode: 13100,
        country: "FR",
        phone: "0123456789"
        ),
        walletId: walletId
        )
        let template = "TEMPLATE_Gx74VpEkJts"
        return FetchPaymentTokenParams(orderRef: orderRef, amount: amout , currencyCode: "EUR", languageCode: "FR", buyer: buyer, customPaymentPageCode: template)
    }
    
    public static func testPaymentFailureParams(walletId: String) -> FetchPaymentTokenParams {
        let orderRef = UUID.init().uuidString
        let buyer = Buyer(
            firstname: "John",
            lastname: "Doe",
            email: "John.Doe@gmail.com",
            mobilePhone: "0123456789",
            shippingAddress: Address(
                firstname: "John",
                lastname: "Doe",
                street1: "1 rue de Rue",
                city: "Aix-en-Provence",
                zipCode: 13100,
                country: "FR",
                phone: "0123456789"
            ),
            walletId: walletId
        )
        let template  = "TEMPLATE_Gx74VpEkJts"
        return FetchPaymentTokenParams(orderRef: orderRef, amount: 33314 , currencyCode: "EUR", languageCode: "FR", buyer: buyer, customPaymentPageCode: template)
    }
}

public struct FetchWalletTokenParams: FetchTokenParams {
    let buyer: Buyer
    let updatePersonalDetails: Bool
    let languageCode: String
    let customPaymentPageCode: String
    
    
  public static func testWalletParams(walletId: String) -> FetchWalletTokenParams{
        return FetchWalletTokenParams(
            buyer: Buyer(
                firstname: "John",
                lastname: "Doe",
                email: "John.Doe@gmail.com",
                mobilePhone: "0123456789",
                shippingAddress: Address(
                    firstname: "John",
                    lastname: "Doe",
                    street1: "1 rue de Rue",
                    city: "Aix-en-Provence",
                    zipCode: 13100,
                    country: "FR",
                    phone: "0123456789"
                ),
                walletId: walletId
            ),
            updatePersonalDetails: false,
            languageCode: "EN",
            customPaymentPageCode: "TEMPLATE_tjrDPqClvLp"
        )
    }
}

public struct Buyer: Encodable {
    let firstname: String
    let lastname: String
    let email: String
    let mobilePhone: String
    let shippingAddress: Address
    let walletId: String
}

public struct Address: Encodable {
    let firstname: String
    let lastname: String
    let street1: String
    let city: String
    let zipCode: Int
    let country: String
    let phone: String
}

