//
//	ListData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListData : Decodable {
	let chartList: [ChartList]
    let sectionList: [SectionList]
    let programCategoryList: ProgramCategoryList
	let videoPlayList: VideoPlayList
}

// MARK: - ChartList Data

extension ListData {
    var chartListCount: Int {
        return chartList.count
    }
}

// MARK: - SectionList Data

extension ListData {
    var sectionListCount: Int {
        return sectionList.count
    }
}

// MARK: - ProgramCategoryList Data

extension ListData {
    var programListCount: Int {
        return programCategoryList.list.count
    }
}

// MARK: - VideoPlayList Data

extension ListData {
    var videoListCount: Int {
        return videoPlayList.videoList.count
    }
}
