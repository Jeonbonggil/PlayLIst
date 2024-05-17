//
//  IndexPath.swift
//  Playlist
//
//  Created by ec-jbg on 5/17/24.
//

import Foundation

extension IndexPath {
    var estimatedHeightKey: String {
        return "\(section)" + "_" + "\(row)"
    }
}
