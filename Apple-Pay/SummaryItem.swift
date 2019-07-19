import Foundation
import PassKit

struct Item {
    let label: String
    let amount: Decimal
}

extension Item {
    var summary: PKPaymentSummaryItem {
        return PKPaymentSummaryItem(label: label,
                                    amount: NSDecimalNumber(decimal: amount),
                                    type: .final)
    }
}
