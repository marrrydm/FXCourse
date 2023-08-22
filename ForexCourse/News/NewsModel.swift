import UIKit

struct NewsModel: Codable {
    var name: String?
    var date: String?
    var comment: String?

    enum CodingKeys: CodingKey {
        case name
        case date
        case comment
    }
}
