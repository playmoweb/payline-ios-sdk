# PaylineSDK

[![CI Status](https://img.shields.io/travis/therealmyluckyday/PaylineSDK.svg?style=flat)](https://travis-ci.org/therealmyluckyday/PaylineSDK)
[![Version](https://img.shields.io/cocoapods/v/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)
[![License](https://img.shields.io/cocoapods/l/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)
[![Platform](https://img.shields.io/cocoapods/p/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)

# Description

Le SDK Payline est un kit de développement qui va permettre d'intéragir avec le service Payline afin d'effectuer un paiement ou de voir le porte-monnaie.

## Example

Pour lancer le projet d'exemple, il vous suffit de cloner ce repo, puis d'executer la commande  `pod install` dans le dossier Example

## Installation

PaylineSDK est disponible via [CocoaPods](https://cocoapods.org).

Pour l'installer:

1. Dans votre Podfile, ajoutez la ligne suivante:
 
 ```ruby 
pod 'PaylineSDK'
 ```
 
 2. Executez la commande suivante à la racine de votre projet:
  `pod install` 

# Utilisation

## Initialisation

Pour l'initialisation du SDK, il faut tout d'abord instancier un  `PaymentController()` et un  `WalletController()` ainsi que leu delegates associés :

```swift
lazy var paymentController: PaymentController = {
    return PaymentController(presentingViewController: UIViewController, delegate: PaymentControllerDelegate)
}()

lazy var walletController: WalletController = {
    return WalletController(presentingViewController: UIViewController, delegate: WalletControllerDelegate)
}()
```
La méthode d'initialisation du paiement requiert deux paramètres: un "PaymentControllerDelegate" et un UIViewController
La méthode d'initialisation du porte-monnaie requiert deux paramètres: un "WalletControllerDelegate" et un UIViewController


Pour que votre UIViewController agisse comme un delegate, vous devez implementer les protocol `PaymentControllerDelegate` et `WalletControllerDelegate`:

```swift
class ViewController: UIViewController, PaymentControllerDelegate, WalletControllerDelegate
```

## Réaliser un paiement

La méthode `showPaymentForm` est utilisée pour afficher la page des moyens de paiement.

```swift

@IBAction func clickedPay(_ sender: Any?) {
    let url = URL(string: ...)
        paymentController.showPaymentForm(environment: url)
    }
```
La récupération du paramètre `url` se fera selon vos choix d'implementation. 
Pour plus d'informations, veuillez vous référer à la documentation Payline en cliquant [ici](https://support.payline.com/hc/fr/articles/360000844007-PW-Int%C3%A9gration-Widget)


La méthode `showManageWallet` est utilisée pour afficher la page du porte-monnaie.

```swift
lazy var walletController: WalletController = {
    return WalletController(presentingViewController: self, delegate: self)
}()
walletController.manageWebWallet(environment: url)
```
Ces deux méthodes requierent l'url de la page vers laquelle nous devons êtres redirigés.

## Exemple d'utilisation

### Initialisation

```swift

class ViewController: UIViewController {

lazy var paymentController: PaymentController = {
    return PaymentController(presentingViewController: self, delegate: self)
}()

lazy var walletController: WalletController = {
    return WalletController(presentingViewController: self, delegate: self)
}()

```

### Implementation des delegates
```swift

extension ViewController: PaymentControllerDelegate {

    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        //handle the action
    }

    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController) {
        //handle the action
    }

    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState) {
        //handle the WidgetState 
    }


    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {
        //handle the action
    }

    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {
        //handle the action
    }

    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {  
        //handle the action
    }

}

extension ViewController: WalletControllerDelegate {

    func walletControllerDidShowWebWebWallet(_ walletController: WalletController) {
        //handle the action
    }

}
```

# Documentation Payline

La documentation de Payline peut être trouvée [ici](https://support.payline.com/hc/fr/categories/200093147-Documentation). Elle offre une vue d'ensemble du système, des détails et des explications sur certains sujets.

---

## Author

Payline, support@payline.com

## License

PaylineSDK is available under the MIT license. See the LICENSE file for more info.



