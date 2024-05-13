//
//	VideoPlayList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VideoPlayList: Decodable {
	let descriptionField: String
	let id: String
	let name: String
	let type: String
	let videoList: [VideoList]
}
