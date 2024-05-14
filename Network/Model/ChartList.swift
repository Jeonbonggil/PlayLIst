//
//	ChartList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ChartList: Decodable {
	let basedOnUpdate: String
	let descriptionField: String
	let id: Int
	let name: String
	let totalCount: Int
	let trackList: [TrackList]
	let type: String
}

extension ChartList {
    func title() -> String {
        return name + " " + basedOnUpdate
    }
    
    func desc() -> String {
        return descriptionField
    }
}
