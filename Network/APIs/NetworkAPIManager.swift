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
    func request<ResponseObject: Decodable>(
        api: Any,
        responseObject: ResponseObject.Type,
        onSuccess success: @escaping (ResponseObject) -> Void,
        onFailure failure: @escaping (NetworkAPIError) -> Void,
        retry: (() -> Void)? = nil
    ) {
        provider.request(api as! NetworkAPI) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                do {
                    let responseObject = try response.map(responseObject.self)
                    success(responseObject)
                } catch {
                    failure(.decodeError(response.description))
                }
            case .failure(let error):
                if retryCount < Self.maxRetryCount {
                    retryCount += 1
                    retry?()
                } else {
                    retryCount = 0
                    if let desc = error.errorDescription {
                        failure(.requestError(desc))
                    } else {
                        failure(.serverError("serverError"))
                    }
                }
            }
        }
    }
    
    /// Music Playlist 가져오기 API
    static func fetchPlayList(
        onSuccess success: @escaping (PlaylistData) -> Void,
        onFailure failure: @escaping failureClosure
    ) {
        shared.request(
            api: NetworkAPI.playlist,
            responseObject: PlaylistData.self,
            onSuccess: success,
            onFailure: failure)
    }
    /// 상세 곡 정보 가져오기 API
    static func fetchTrackData(
        trackID: Int,
        onSuccess success: @escaping (TrackData) -> Void,
        onFailure failure: @escaping failureClosure
    ) {
        shared.request(
            api: NetworkAPI.trackDetail(trackID: trackID),
            responseObject: TrackData.self,
            onSuccess: success,
            onFailure: failure)
    }
}
