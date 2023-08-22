struct QuizeModel: Codable {
    var question: [String]
    var answer: [String]
    var nameImg: [String]
    var trueAnswer: [Int]

    enum CodingKeys: CodingKey {
        case question
        case answer
        case nameImg
        case trueAnswer
    }
}
