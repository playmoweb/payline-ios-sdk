# PaylineSDK

[![CI Status](https://img.shields.io/travis/therealmyluckyday/PaylineSDK.svg?style=flat)](https://travis-ci.org/therealmyluckyday/PaylineSDK)
[![Version](https://img.shields.io/cocoapods/v/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)
[![License](https://img.shields.io/cocoapods/l/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)
[![Platform](https://img.shields.io/cocoapods/p/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)

# Description

Le SDK Payline est un kit de développement qui va permettre d'intéragir avec le service Payline afin d'effectuer un paiement ou de voir le porte-monnaie.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PaylineSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PaylineSDK'
```
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

## Configuration

La méthode `showPaymentForm` est utilisée pour afficher la page des moyens de paiement.

```swift
lazy var paymentController: PaymentController = {
    return PaymentController(presentingViewController: self, delegate: self)
}()
paymentController.showPaymentForm(environment: url)
```

OR

La méthode `showManageWallet` est utilisée pour afficher la page du porte-monnaie.

```swift
lazy var walletController: WalletController = {
    return WalletController(presentingViewController: self, delegate: self)
}()
walletController.manageWebWallet(environment: URL)
```
Ces deux méthodes requierent l'url de la page vers laquelle nous devons êtres redirigés.

# Documentation Payline

La documentation de Payline peut être trouvée [ici](https://support.payline.com/hc/fr/categories/200093147-Documentation). Elle offre une vue d'ensemble du système, des détails et des explications sur certains sujets.

---

## Author

Payline, support@payline.com

## License

PaylineSDK is available under the MIT license. See the LICENSE file for more info.



