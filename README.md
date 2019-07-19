# Pay Sample

This sample code integrates last [PassKitk](https://developer.apple.com/documentation/passkit) API in order to provide an overview about Pay client integration (iOS only).

## Buttons

### Customize Pay button:

```
let paymentButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
```

### Available types:
```
public enum PKPaymentButtonType : Int {
    case plain

    case buy

    @available(iOS 9.0, *)
    case setUp

    @available(iOS 10.0, *)
    case inStore

    @available(iOS 10.2, *)
    case donate

    @available(iOS 12.0, *)
    case checkout

    @available(iOS 12.0, *)
    case book

    @available(iOS 12.0, *)
    case subscribe
}
```

### Available styles:
```
public enum PKPaymentButtonStyle : Int {
    case white
    case whiteOutline
    case black
}
```

# Payment Authorization

```
func payNow() {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: FakeData.paymentInfo()) {
            let request = ///bla bla bla
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)

            if let viewController = authorizationViewController {
                viewController.delegate = self
                present(viewController, animated: true, completion: nil)
            }
        }
    }
```

### Delegates:

```
public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss Pay sheet
        dismiss(animated: true, completion: nil)
    }

    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("🔑 \(payment.token.transactionIdentifier)")
        print("🔐 \(payment.token.paymentData)")

        // In house API calls
        // Bla Bla Bla

        print("✅ SUCCESS ✅\n")
        return completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

        //print("❌ FAILURE ❌")
        //completion(PKPaymentAuthorizationResult(status: .failure, errors: []))
    }

    public func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        print("🔓 User authenticated")
        // Do some stuff
    }
```

### `paymentAuthorizationViewControllerWillAuthorizePayment`
Called before the payment is authorized, but after the user has authenticated using passcode or Touch ID.

### `paymentAuthorizationViewController`
Called after the user has acted on the payment request.

* Invoke
`completion(PKPaymentAuthorizationResult(status: .success, errors: nil))`
to **authorize** the transaction.

* Invoke
`completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))`
to **decline** the transaction.

You may use custom errors if needed:
```
completion(PKPaymentAuthorizationResult(status: .failure, 
                                        errors: [PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "!Fatal error!")]))
```

### `paymentAuthorizationViewControllerDidFinish`
Called when payment authorization is finished.  This may occur when the user cancels the request or when `completion(PKPaymentAuthorizationResult(status: <status>, errors: <errors>))` of  `paymentAuthorizationViewController` has been invoked.

# Pay Request Creation

Wrapping request in a custom `Payment` object

```
let request = Payment(id: FakeData.merchantInfo(),
                      currency: FakeData.currencyInfo(),
                      networks: FakeData.paymentInfo(),
                      shipping: FakeData.shippingInfo().address,
                      billing: nil,
                      methods: FakeData.shippingMethodInfo(),
                      summary: FakeData.summaryInfo(),
                      requiredFields: FakeData.shippingInfo().requiredFields).request
```

```
struct Currency {
    let country: String
    let id: String
}

struct Payment {
    let id: String
    let currency: Currency
    let networks: [PKPaymentNetwork]
    let shipping: PKContact?
    let billing: PKContact?
    let methods: [PKShippingMethod]?
    let summary: [PKPaymentSummaryItem]
    let requiredFields: Set<PKContactField>
}

extension Payment {
    var request: PKPaymentRequest {
        let req = PKPaymentRequest()
        req.merchantCapabilities = .capability3DS
        req.supportedNetworks = networks
        req.merchantIdentifier = id
        req.currencyCode = currency.id
        req.countryCode = currency.country
        req.paymentSummaryItems = summary
        req.requiredShippingContactFields = requiredFields
        req.shippingContact = shipping
        req.shippingMethods = methods
        return req
    }
}
```

... using `FakeData` model, in ordet to simulate client data injection:

```
struct FakeData {
    static func merchantInfo() -> String {
        return "<your-merch-id-here>"
    }
    
    static func currencyInfo() -> Currency {
        return Currency(country: "IT",
                        id: "EUR")
    }
    
    static func shippingInfo() -> Contact {
        let contact = Contact(email: "mattia.cantalu@ynap.com",
                              name: "Mattia Cantalu",
                              cap: "40069",
                              street: "via nerio nannetti 1",
                              country: "Italia",
                              countryCode: "IT",
                              city: "Zola Predosa",
                              state: "Italia",
                              phone: "+3939339393",
                              requiredFields: [.postalAddress])
        return contact
    }
    
    static func shippingMethodInfo() -> [PKShippingMethod] {
        let shipping = Shipping(id: "a1b2bc",
                                detail: "1day Delivery",
                                title: "Fast shipping",
                                amount: 10.00)
        return [shipping.method]
    }
    
    static func summaryInfo() -> [PKPaymentSummaryItem] {
        let tshirt = Item(label: "Subtotal", amount: 1.00).summary
        let shipping = Item(label: "Shipping", amount: 1.00).summary
        let tax = Item(label: "Sales Tax", amount: 0.00).summary
        let total = Item(label: "Total", amount: 2.00).summary
        return [tshirt, shipping, tax, total]
    }

    static func paymentInfo() -> [PKPaymentNetwork] {
        return [.amex, .masterCard, .visa]
    }

    static func fakeError() -> Error {
        return PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "!Fatal error!")
    }
}
```

# Workflow

### Buttons

![Imgur](https://i.imgur.com/xblZvvt.png)

### Pay
![Imgur](https://i.imgur.com/0nCXBrf.png)

### Payment failure

![Imgur](https://i.imgur.com/9pKIq2H.png)
![Imgur](https://i.imgur.com/Ztnr6y4.png)
![Imgur](https://i.imgur.com/1jKApw6.png)

### Payment success

![Imgur](https://i.imgur.com/NkJSNES.png)

## Requirements
• Swift 5

• Xcode 10.2