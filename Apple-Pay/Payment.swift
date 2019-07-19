import Foundation
import PassKit

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


