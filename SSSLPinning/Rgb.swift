
import Foundation
struct Rgb : Codable {
	let red : Int?
	let green : Int?
	let blue : Int?

	enum CodingKeys: String, CodingKey {

		case red = "red"
		case green = "green"
		case blue = "blue"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		red = try values.decodeIfPresent(Int.self, forKey: .red)
		green = try values.decodeIfPresent(Int.self, forKey: .green)
		blue = try values.decodeIfPresent(Int.self, forKey: .blue)
	}

}
