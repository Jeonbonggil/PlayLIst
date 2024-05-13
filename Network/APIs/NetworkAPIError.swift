//
//  NetworkAPIError.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import Foundation

public enum NetworkAPIError: Error {
    case requestError(_ description: String)
    case serverError(_ description: String)
    case decodeError(_ description: String)
    
    var localizedDescription: String {
        return message()
    }
    
    func message() -> String {
        switch self {
        case .requestError(let description):
            return "requestError: \(description)"
        case .decodeError(let description):
            return "decodeError: \(description)"
        case .serverError(let description):
            return "serverError: \(description)"
        }
    }
}
