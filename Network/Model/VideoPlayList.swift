//
//	VideoPlayList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VideoPlayList: Decodable {
	let description: String
	let id: String?
	let name: String
	let type: String
	let videoList: [VideoList]
}

extension VideoPlayList {
    var listCount: Int {
        return videoList.count - 1
    }
    
    var listFromSecond: [VideoList] {
        let videoList = videoList.dropFirst().map { $0 }
        return videoList
    }
}
