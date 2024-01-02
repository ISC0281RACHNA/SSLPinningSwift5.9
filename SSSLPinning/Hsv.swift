
import Foundation
struct Hsv : Codable {
	let hue : Int?
	let saturation : Int?
	let value : Int?

	enum CodingKeys: String, CodingKey {

		case hue = "hue"
		case saturation = "saturation"
		case value = "value"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		hue = try values.decodeIfPresent(Int.self, forKey: .hue)
		saturation = try values.decodeIfPresent(Int.self, forKey: .saturation)
		value = try values.decodeIfPresent(Int.self, forKey: .value)
	}

}
