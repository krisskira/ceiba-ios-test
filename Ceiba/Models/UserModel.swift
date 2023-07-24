import Foundation

struct UserModel: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address?
    var phone: String
    var website: String
    var company: Company?
    
    init(id: Int, name: String, username: String, email: String, address: Address? = nil, phone: String, website: String, company: Company? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }

    init(){
        id = 0
        name = ""
        username = ""
        email = ""
        phone = ""
        website = ""
        company = Company()
        address = Address()
    }
}

struct Address: Codable, Hashable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo?
    init(street: String, suite: String, city: String, zipcode: String, geo: Geo? = nil) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
    init(){
        self.street = ""
        self.suite = ""
        self.city = ""
        self.zipcode = ""
        self.geo = Geo()
    }
}

struct Geo: Codable, Hashable {
    var lat: String
    var lng: String
    init() {
        lat = "0.0"
        lng = "0.0"
    }
    init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
    }
}

struct Company: Codable, Hashable {
    var name: String
    var catchPhrase: String
    var bs: String

    init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }

    init() {
        self.name = ""
        self.catchPhrase = ""
        self.bs = ""
    }
}
