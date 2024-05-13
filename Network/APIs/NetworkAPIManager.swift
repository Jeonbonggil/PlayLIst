//
//  NetworkAPIManager.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import Foundation
import Moya

final public class NetworkAPIManager {
    typealias failureClosure = (NetworkAPIError) -> Void
    static let shared = NetworkAPIManager()
    static let maxRetryCount = 3
    private var retryCount = 0
    private let provider = MoyaProvider<NetworkAPI>()
    
    /// API 요청
    func requestAPI<ResponseObject: Decodable>(api: TargetType) async throws -> ResponseObject {
        let result = await provider.request(api)
        do {
            let response = try result.get()
            let object = try response.map(ResponseObject.self)
            switch response.statusCode {
            case 200...299:
                return object
            case 400...499:
                throw NetworkAPIError.requestError(response.description)
            case 500...599:
                throw NetworkAPIError.serverError(response.description)
            default:
                throw NetworkAPIError.decodeError(response.description)
            }
        } catch {
            throw NetworkAPIError.decodeError(try result.get().description)
        }
    }
    /// Music Playlist 가져오기 API
    static func fetchPlayList() async throws -> PlaylistData {
        try await shared.requestAPI(api: NetworkAPI.playlist)
    }
    
    /// 곡 상세 정보 가져오기 API
    static func fetchSongDetail(trackID: String) async throws -> SongData {
        try await shared.requestAPI(api: NetworkAPI.songDetail(trackID: trackID))
    }
}

extension MoyaProvider {
    func request(_ target: TargetType) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target as! Target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
