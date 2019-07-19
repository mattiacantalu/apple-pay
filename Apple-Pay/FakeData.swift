import Foundation
import PassKit

struct FakeData {
    static func merchantInfo() -> String {
        return "<your-merch-id-here>"
    }
    
    static func currencyInfo() -> Currency {
        return Currency(country: "IT",
                        id: "EUR")
    }
    
    static func shippingInfo() -> Contact {
        let contact = Contact(email: "<sample@email.com>",
                              name: "<name surname>",
                              cap: "<postal code>",
                              street: "<street name>",
                              country: "<country name>",
                              countryCode: "<contry code>",
                              city: "<city name>",
                              state: "<state>",
                              phone: "<0123456789>",
                              requiredFields: [.postalAddress, .emailAddress, .name])
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
