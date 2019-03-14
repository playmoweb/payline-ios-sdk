//
//  WalletControllerDelegate.swift
//  PaylineSDK
//
//  Created by Rayan Mehdi on 05/03/2019.
//

import Foundation

/**
 *
 * Le WalletControllerDelegate est une interface qui définit la communication entre le WalletController et l'application.
 */

public protocol WalletControllerDelegate: class {
    /**
     * Appelée lorsque le porte-monnaie a été affiché
     *
     * - Parameter walletController: Le walletController qui appel la méthode du delegate
     */
    func walletControllerDidShowWebWebWallet(_ walletController: WalletController)
}
