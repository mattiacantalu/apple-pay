import Foundation
import PassKit

struct Shipping {
    let id: String
    let detail: String
    let title: String
    let amount: Decimal
}

extension Shipping {
    var method: PKShippingMethod {
        let met = PKShippingMethod(label: title,
                                   amount: NSDecimalNumber(decimal: amount),
                                   type: PKPaymentSummaryItemType(rawValue: 0)!)
        met.detail = detail
        met.identifier = id
        return met
    }
}
