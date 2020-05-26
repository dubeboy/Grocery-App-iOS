
import Foundation

struct Grocery: Codable {
    let name: String
    var id: Int?
    let available: Bool
}

struct StatusReponse<T: Decodable> : Decodable {
    let status: Bool
    let message: String
    let entity: T
}
