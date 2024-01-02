

import Foundation

struct Dog: Codable {
    let message: String?
    let status: String?
}

struct ColorResult: Codable {
    let results: [ColorFul]
}

struct ColorFul : Codable {
	let id : Int?
	let title : String?
	let userName : String?
	let numViews : Int?
	let numVotes : Int?
	let numComments : Int?
	let numHearts : Int?
	let rank : Int?
	let dateCreated : String?
	let hex : String?
	let rgb : Rgb?
	let hsv : Hsv?
	let description : String?
	let url : String?
	let imageUrl : String?
	let badgeUrl : String?
	let apiUrl : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case userName = "userName"
		case numViews = "numViews"
		case numVotes = "numVotes"
		case numComments = "numComments"
		case numHearts = "numHearts"
		case rank = "rank"
		case dateCreated = "dateCreated"
		case hex = "hex"
		case rgb = "rgb"
		case hsv = "hsv"
		case description = "description"
		case url = "url"
		case imageUrl = "imageUrl"
		case badgeUrl = "badgeUrl"
		case apiUrl = "apiUrl"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
		numViews = try values.decodeIfPresent(Int.self, forKey: .numViews)
		numVotes = try values.decodeIfPresent(Int.self, forKey: .numVotes)
		numComments = try values.decodeIfPresent(Int.self, forKey: .numComments)
		numHearts = try values.decodeIfPresent(Int.self, forKey: .numHearts)
		rank = try values.decodeIfPresent(Int.self, forKey: .rank)
		dateCreated = try values.decodeIfPresent(String.self, forKey: .dateCreated)
		hex = try values.decodeIfPresent(String.self, forKey: .hex)
		rgb = try values.decodeIfPresent(Rgb.self, forKey: .rgb)
		hsv = try values.decodeIfPresent(Hsv.self, forKey: .hsv)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
		badgeUrl = try values.decodeIfPresent(String.self, forKey: .badgeUrl)
		apiUrl = try values.decodeIfPresent(String.self, forKey: .apiUrl)
	}

}
