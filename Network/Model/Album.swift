//
//	Album.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Album: Decodable {
	let id: Int
	let imgList: [ImgList]
	let title: String
}
