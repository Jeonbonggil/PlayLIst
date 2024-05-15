//
//	List.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct List: Decodable {
	let displayTitle: String
	let imgUrl: String?
	let programCategoryId: Int
	let programCategoryType: String
}

extension List {
    var imgListURL: URL {
        guard let imgUrl else { return URL(string: "")! }
        return URL(string: imgUrl)!
    }
}
