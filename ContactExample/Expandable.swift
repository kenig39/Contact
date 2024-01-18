
import Foundation
import Contacts

struct Expandable {
    var isExpanded: Bool
    var nameContact: [FavotitedContact]
}

struct FavotitedContact {
    let contact: CNContact
    var Favorite: Bool
}
