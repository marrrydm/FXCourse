struct LessonModel: Codable {
    var content: [String]
    var description: [String]
    var nameImg: [String]

    enum CodingKeys: CodingKey {
        case content
        case description
        case nameImg
    }
}
