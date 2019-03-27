# PaylineSDK

## Utilisation

### Initialisation

Pour l'initialisation du SDK, il faut tout d'abord instancier un  `PaymentController()` et un  `WalletController()` ainsi que leurs delegates associés :

```swift
lazy var paymentController: PaymentController = {
return PaymentController(presentingViewController: UIViewController, delegate: PaymentControllerDelegate)
}()

lazy var walletController: WalletController = {
return WalletController(presentingViewController: UIViewController, delegate: WalletControllerDelegate)
}()
```
La méthode d'initialisation du paiement requiert deux paramètres: un "PaymentControllerDelegate" et un UIViewController
La méthode d'initialisation du portefeuille requiert deux paramètres: un "WalletControllerDelegate" et un UIViewController


Pour que votre UIViewController agisse comme un delegate, vous devez implementer les protocol `PaymentControllerDelegate` et `WalletControllerDelegate`:

```swift
class ViewController: UIViewController, PaymentControllerDelegate, WalletControllerDelegate
```

## Configuration

### Réaliser un paiement

La méthode `showPaymentForm` est utilisée pour afficher la page des moyens de paiement.

```swift

@IBAction func clickedPay(_ sender: Any?) {
let url = URL(string: ...)
paymentController.showPaymentForm(environment: url)
}
```
La récupération du paramètre `url` se fera selon vos choix d'implementation. 
Pour plus d'informations, veuillez vous référer à la documentation Payline en cliquant [ici](https://support.payline.com/hc/fr/articles/360000844007-PW-Int%C3%A9gration-Widget)


### Accéder au portefeuille

La méthode `showManageWallet` est utilisée pour afficher la page du portefeuille.

```swift
@IBAction func clickedManageWallet(_ sender: Any?) {
let url = URL(string: ...) {
walletController.manageWebWallet(environment: url)
}
```
Comme pour la réaisation d'un paiement, la récupération du paramètre `url` se fera selon vos choix d'implementation. 
Pour plus d'informations, veuillez vous référer à la documentation Payline en cliquant [ici](https://support.payline.com/hc/fr/articles/360000844007-PW-Int%C3%A9gration-Widget)

### PaymentController

Une fois que la page des moyens de paiement a été affichée, plusieurs méthodes sont accessibles:

```swift
public func updateWebPaymentData(_ webPaymentData: String)
```
`updateWebPaymentData` permet de mettre à jour les informations de session de paiement après l'initialisation du widget et avant la finalisation du paiement.


```swift
public func getIsSandbox()
```
`getIsSandbox` permet de savoir si l'environnement est une production ou une homologation.


```swift
public func endToken(additionalData: Encodable?, isHandledByMerchant: Bool)
```
`endToken` permet de mettre fin à la vie du jeton de session web.


```swift
public func getLanguage()
```
`getLanguage` permet de connaitre la clé du language du widget.


```swift
public func getContextInfo(key: ContextInfoKey)
```
`getContextInfo` permet de connaitre l'information dont la clé est passée en paramètre.
Les différentes clés disponibles pour cette fonction sont les suivantes:

```swift

public enum ContextInfoKey: String {

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

```
### PaymentControllerDelegate

Le `PaymentControllerDelegate` est une interface qui définit la communication entre l'application et le PaymentController. Il va permettre d'avertir la classe qui l'implémente lorsque des données ou des actions sont reçues. Il contient différentes méthodes:

```swift
func paymentControllerDidShowPaymentForm(_ paymentController: PaymentController)
```
`paymentControllerDidShowPaymentForm(_:)` est la méthode appelée lorsque la liste des moyens de paiement a été affichée.


```swift
func paymentControllerDidFinishPaymentForm(_ paymentController: PaymentController, withState state: WidgetState)
```
`paymentControllerDidFinishPaymentForm(_:withState:)` est la méthode appelée lorsque le paiement a été terminé. Elle reçoit en paramètre un objet de type  `widgetState` qui correspond aux différents états possible lors de la fin du paiement. Cet objet peut prendre les valeurs suivantes:

```swift
public enum WidgetState: String {

    case paymentMethodsList = "PAYMENT_METHODS_LIST"
    case paymentCanceled = "PAYMENT_CANCELED"
    case paymentSuccess = "PAYMENT_SUCCESS"
    case paymentFailure = "PAYMENT_FAILURE"
    case paymentFailureWithRetry = "PAYMENT_FAILURE_WITH_RETRY"
    case tokenExpired = "TOKEN_EXPIRED"
    case browserNotSupported = "BROWSER_NOT_SUPPORTED"
    case paymentMethodNeedsMoreInfo = "PAYMENT_METHOD_NEEDS_MORE_INFOS"
    case paymentRedirectNoResponse = "PAYMENT_REDIRECT_NO_RESPONSE"
    case manageWebWallet = "MANAGED_WEB_WALLET"
    case activeWaiting = "ACTIVE_WAITING"
    case paymentCanceledWithRetry = "PAYMENT_CANCELED_WITH_RETRY"
    case paymentOnHoldPartner = "PAYMENT_ONHOLD_PARTNER"
    case paymentSuccessForceTicketDisplay = "PAYMENT_SUCCESS_FORCE_TICKET_DISPLAY"
}
```

```swift
func paymentController(_ paymentController: PaymentController, didGetIsSandbox: Bool)

```
`paymentController(_:didGetIsSandbox:)` est la méthode appelée lorsque l'environnement a été reçu. `isSandbox`  vaudra true si l'environnement est une production et false si c'est une homologation.


```swift
func paymentController(_ paymentController: PaymentController, didGetLanguage: String)
```
`paymentController(_:didGetLanguage:)` est la méthode appelée lorsque la clé du language du widget est connue. `language` peut avoir des valeurs comme "fr", "en" ...


```swift
func paymentController(_ paymentController: PaymentController, didGetContextInfo: ContextInfoResult)
```
`paymentController(_:didGetContextInfo:)` est la méthode appelée lorsque l'information du contexte est connue.
Le paramètre `didGetContextInfo`est de type `ContextInfoResult`. Il s'agit d'une enum qui va être utilisée pour traiter le résultat obtenu par la wevView. Trois types de données pourront être reçus: 
```swift

public enum ContextInfoResult {

    case int(ContextInfoKey, Int)
    case string(ContextInfoKey, String)
    case objectArray(ContextInfoKey, [[String: Any]])
}

```

### WalletControllerDelegate

Le `WalletControllerDelegate` est une interface qui définit la communication entre l'application et le WalletController. Il va permettre d'avertir la classe qui l'implémente lorsque des données ou des actions sont reçues. Il contient une méthode:

```swift
func walletControllerDidShowWebWallet(_ walletController: WalletController)
```
`walletControllerDidShowWebWebWallet(_:)` est la méthode appelée lorsque le portefeuille a été affiché.
