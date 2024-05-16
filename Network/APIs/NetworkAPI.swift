//
//  NetworkAPI.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import Foundation
import Moya

public enum NetworkAPI {
    case playlist
    case trackDetail(trackID: Int)
}

extension NetworkAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com")!
    }
    public var path: String {
        switch self {
        case .playlist:
            return "dreamus-ios/challenge/main/browser"
        case .trackDetail(let trackID):
            return "dreamus-ios/challenge/main/track/\(trackID)"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .playlist, .trackDetail:
            return .get
        }
    }
    public var task: Task {
        switch self {
        case .playlist, .trackDetail:
            return .requestPlain
        }
    }
    public var validationType: ValidationType {
        switch self {
        case .playlist, .trackDetail:
            return .successCodes
        }
    }
    public var headers: [String: String]? {
        let headers = ["Accept": "*/*", "Content-Type": "application/json"]
        return headers
    }
}
