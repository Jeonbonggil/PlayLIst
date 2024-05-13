//
//	Data.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Data : Decodable {
	let chartList: [ChartList]
	let programCategoryList: ProgramCategoryList
	let sectionList: [SectionList]
	let videoPlayList: VideoPlayList
}
