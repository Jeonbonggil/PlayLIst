//
//	SectionList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SectionList : Decodable {
	let name : String
	let shortcutList : [ShortcutList]?
	let type : String
}
