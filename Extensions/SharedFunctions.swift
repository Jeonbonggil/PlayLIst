//
//  SharedFunctions.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/4/24.
//

import UIKit

internal func classNameWithoutModule(_ class: AnyClass) -> String {
  return `class`
    .description()
    .components(separatedBy: ".")
    .dropFirst()
    .joined(separator: ".")
}
