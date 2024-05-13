//
//	Data.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SongData: Decodable {
	let album: Album
	let id: Int
	let lyrics: String
	let name: String
	let playTime: String
	let representationArtist: RepresentationArtist
	let trackArtistList: [TrackArtistList]
}
