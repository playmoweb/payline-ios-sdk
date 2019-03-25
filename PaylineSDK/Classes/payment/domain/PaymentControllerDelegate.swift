//
//  PaymentControllerDelegate.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation

public protocol PaymentControllerDelegate: class {
    /**
     * Appelée lorsque la liste des moyens de paiement a été affichée
     
     * - Parameter paymentController: Le paymentController qui appel la méthode du delegate
     
     * [PW - API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     */
    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController)
    
    /**
     * Appelée lorsque le paiement a été terminé
     *
     * - Parameters:
     *   - paymentController: Le paymentController qui appel la méthode du delegate
     *   - state: L'état reçu dans le callback
     
     * [PW - API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     */
    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState)
        
    /**
     * Appelée lorsque l'environnement est connu
     *
     *
     * - Parameters:
     *   - paymentController: Le paymentController qui appel la méthode du delegate
     *   - didGetIsSandbox: didGetIsSandbox est à true si l'environnement une production et à false lorsque c'est une homologation
     *
     * [PW - API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     *
     */
    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool)
    
    /**
     * Appelée lorsque la clé du language du widget est connue
     *
     
     * - Parameters:
     *   - paymentController: Le paymentController qui appel la méthode du delegate
     *   - didGetLanguage: didGetLanguage correspond à la langue du widget
     
     * [PW - API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     */
    func paymentController(_ paymentController: PaymentController, didGetLanguage: String)
    
    /**
     * Appelée lorsque l'information du contexte est connue
     
     * - Parameters:
     *    - paymentController: Le paymentController qui appel la méthode du delegate
     *    - didGetContextInfo: Le resultat de la methode getContextInfo(key)
     *
     * [PW - API JavaScript](https://support.payline.com/hc/fr/articles/360017949833-PW-API-JavaScript)
     */
    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult)
}
 
