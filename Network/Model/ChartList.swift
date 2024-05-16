//
//	ChartList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ChartList: Decodable {
	let basedOnUpdate: String
	let description: String
	let id: Int
	let name: String
	let totalCount: Int
	let trackList: [TrackList]?
	let type: String
}

extension ChartList {
    var trackCount: Int {
        return trackList?.count ?? 0
    }
}
