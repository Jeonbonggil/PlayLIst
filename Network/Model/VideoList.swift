//
//	VideoList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VideoList: Decodable {
	let id: Int
	let playTm: String
	let representationArtist: RepresentationArtist
	let thumbnailImageList: [ThumbnailImageList]
	let videoNm: String
}
