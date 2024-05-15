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

extension VideoList {
    var thumbnailURL: URL {
        guard let url = thumbnailImageList.first?.url else { return URL(string: "")! }
        return URL(string: url)!
    }
    
    var artistName: String {
        return representationArtist.name
    }
}
