//
//	TrackList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TrackList: Decodable {
	let album: Album
	let id: Int
	let name: String
	let representationArtist: RepresentationArtist
}

extension TrackList {
    var songTitle: String {
        return name
    }
    var imgURL: URL {
        guard let url = album.imgList.first?.url else { return URL(string: "")! }
        return URL(string: url)!
    }
    var artistName: String {
        return representationArtist.name
    }
}
