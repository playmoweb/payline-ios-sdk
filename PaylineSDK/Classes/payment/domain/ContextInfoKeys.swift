//
//  ContextInfoKeys.swift
//  PaylineSDK
//
//  Created by Rayan Mehdi on 28/02/2019.
//

import Foundation

public enum ContextInfoKeys: String {
    
    case paylineAmountSmallestUnit = "PaylineAmountSmallestUnit"
    case paylineCurrencyDigits  = "PaylineCurrencyDigits"
    case paylineCurrencyCode = "PaylineCurrencyCode"
    case paylineBuyerFirstName = "PaylineBuyerFirstName"
    case paylineBuyerLastName = "PaylineBuyerLastName"
    case paylineBuyerShippingAddressStreet2 = "PaylineBuyerShippingAddress.street2"
    case paylineBuyerShippingAddressCountry = "PaylineBuyerShippingAddress.country"
    case paylineBuyerShippingAddressName = "PaylineBuyerShippingAddress.name"
    case paylineBuyerShippingAddressStreet1 = "PaylineBuyerShippingAddress.street1"
    case paylineBuyerShippingAddressCityName = "PaylineBuyerShippingAddress.cityName"
    case paylineBuyerShippingAddressZipCode = "PaylineBuyerShippingAddress.zipCode"
    case paylineBuyerMobilePhone = "PaylineBuyerMobilePhone"
    case paylineBuyerShippingAddressPhone = "PaylineBuyerShippingAddress.phone"
    case paylineBuyerIp = "PaylineBuyerIp"
    case paylineFormattedAmount = "PaylineFormattedAmount"
    case paylineOrderDate = "PaylineOrderDate"
    case paylineOrderRef = "PaylineOrderRef"
    case paylineOrderDeliveryMode = "PaylineOrderDeliveryMode"
    case paylineOrderDeliveryTime = "PaylineOrderDeliveryTime"
    case paylineOrderDetails = "PaylineOrderDetails"
    
}
