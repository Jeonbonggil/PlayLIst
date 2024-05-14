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
    case songDetail(trackID: String)
}

extension NetworkAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com")!
    }
    public var path: String {
        switch self {
        case .playlist:
            return "dreamus-ios/challenge/main/browser"
        case .songDetail:
            return "dreamus-ios/challenge/main/track"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .playlist, .songDetail:
            return .get
        }
    }
    public var task: Task {
        switch self {
        case .playlist:
            return .requestPlain
        case .songDetail(let trackID):
            return .requestParameters(
                parameters: ["trackID": trackID],
                encoding: URLEncoding.default
            )
        }
    }
    public var validationType: ValidationType {
        switch self {
        case .playlist, .songDetail:
            return .successCodes
        }
    }
    public var headers: [String: String]? {
        let headers = ["Accept": "*/*", "Content-Type": "application/json"]
        return headers
    }
}
