import Foundation
import PassKit

struct Contact {
    let email: String
    let name: String
    let cap: String
    let street: String
    let country: String
    let countryCode: String
    let city: String
    let state: String
    let phone: String
    let requiredFields: Set<PKContactField>
}

extension Contact {
    var address: PKContact {
        let contact = PKContact()
        contact.emailAddress = email
        contact.name = personNameComponent()
        contact.postalAddress = postalAddress()
        contact.phoneNumber = phoneNumber()
        return contact
    }
}

fileprivate extension Contact {
    func personNameComponent() -> PersonNameComponents {
        var compName = PersonNameComponents()
        compName.givenName = name
        return compName
    }

    func postalAddress() -> CNMutablePostalAddress {
        let address = CNMutablePostalAddress()
        address.postalCode = cap
        address.street = street
        address.isoCountryCode = countryCode
        address.country = country
        address.city = city
        address.state = state
        return address
    }

    func phoneNumber() -> CNPhoneNumber {
        return CNPhoneNumber(stringValue: phone)
    }
}
