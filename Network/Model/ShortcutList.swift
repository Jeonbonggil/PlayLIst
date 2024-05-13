//
//	ShortcutList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ShortcutList : Decodable {
	let id : Int
	let imgList : [ImgList]
	let name : String
	let type : String
}
