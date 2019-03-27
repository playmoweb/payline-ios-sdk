# PaylineSDK

[![CI Status](https://img.shields.io/travis/therealmyluckyday/PaylineSDK.svg?style=flat)](https://travis-ci.org/therealmyluckyday/PaylineSDK)
[![Version](https://img.shields.io/cocoapods/v/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)
[![License](https://img.shields.io/cocoapods/l/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)
[![Platform](https://img.shields.io/cocoapods/p/PaylineSDK.svg?style=flat)](https://cocoapods.org/pods/PaylineSDK)

# Description

Le SDK Payline est un kit de développement qui va permettre d'intéragir avec le service Payline afin d'effectuer un paiement ou de voir le porte-monnaie.

## Exemple

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


## Accéder au portefeuille


La méthode `showManageWallet` est utilisée pour afficher la page du porte-monnaie.

```swift
@IBAction func clickedManageWallet(_ sender: Any?) {
    let url = URL(string: ...) {
    walletController.manageWebWallet(environment: url)
}
```
Comme pour la réaisation d'un paiement, la récupération du paramètre `url` se fera selon vos choix d'implementation. 
Pour plus d'informations, veuillez vous référer à la documentation Payline en cliquant [ici](https://support.payline.com/hc/fr/articles/360000844007-PW-Int%C3%A9gration-Widget)

## Implémentation des delegates

### PaymentControllerDelegate

Le PaymentControllerDelegate est une interface qui définit la communication entre l'application et le PaymentController.

Ce dernier nécessite l'implémentation de cinq methodes:

- `paymentControllerDidShowPaymentForm(_:)` : Méthode appelé lorsque la liste des moyens de paiement a été afichée.

-  `paymentControllerDidFinishPaymentForm(_:withState:)`: Méthode appelé lorsque le paiement est terminé. Cette méthode prends en paramètre un objet de type `WidgetState` qui est une énumération des différents valeurs possible pour la propriété state retourné par les fonctions callback du widget.

- `paymentController(_:didGetIsSandbox:)`: Méthode appelé lorsque l'environnement de paiement est connu(environnement de test ou de production).

- `paymentController(_:didGetLanguage:)`: Méthode appelé lorsque la langue du widget est connue.

- `paymentController(_:didGetContextInfo:)`: Méthode appelé à la récupération d'une information sur le contexte de paiement.


### WalletControllerDelegate

Le WalletControllerDelegate est une interface qui définit la communication entre le WalletController et l'application.

Ce dernier nécessite l'implémentation d'une méthode:

`walletControllerDidShowWebWebWallet(_:)`: Méthode appelé lorsque la page de gestion du portefeuille a été affichée



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

### Effectuer un paiement

```swift

@IBAction func clickedPay(_ sender: Any?) {
    let url = URL(string: ...)
    //On appelle la méthode showPaymentForm avec l'url du tunnel de paiement récupéré en fonction de votre implémentation
    paymentController.showPaymentForm(environment: url)
}

```

### Affichage du Wallet 

```@IBAction func clickedManageWallet(_ sender: Any?) {
    let url = URL(string: ...)
    //On appelle la méthode manageWebWallet avec l'url du wallet récupéré en fonction de votre implémentation.
    paymentController.manageWebWallet(environment: url)
}
```

### Implementation des delegates
```swift

extension ViewController: PaymentControllerDelegate {

    func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController) {
        //Gérer l'action ici
    }

    func paymentControllerDidCancelPaymentForm(_ paymentController: PaymentController) {
        //Gérer l'action ici
    }

    func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState) {
        //Gérer le WidgetState ici
    }


    func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool) {
        //Gérer l'action ici
    }

    func paymentController(_ paymentController: PaymentController, didGetLanguage: String) {
        //Gérer l'action ici
    }

    func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult) {  
        //Gérer l'action ici
    }

}

extension ViewController: WalletControllerDelegate {

    func walletControllerDidShowWebWebWallet(_ walletController: WalletController) {
        //Gérer l'action ici
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



