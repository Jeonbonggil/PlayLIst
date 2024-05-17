//
//  PlaylistReactor.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import RxSwift
import ReactorKit

enum SectionType: Int, CaseIterable {
    case rankChart
    case sectionList
    case categoryList
    case videoList
}

final class PlaylistReactor: Reactor {
    enum Action {
        case headerIndex(Int)
        case loadPlaylist
        case selectTrack(Int)
        case getError(NetworkAPIError)
    }
    
    enum Mutation {
        case sendHeaderIndex(Int)
        case setPlayList(PlaylistData)
        case fetchTrackData(TrackData)
        case sendError(NetworkAPIError)
    }
    
    struct State {
        var headerIndex: Int?
        var playList: ListData?
        var trackData: SongData?
        var error: NetworkAPIError?
    }
    
    let initialState: State = State()
}

extension PlaylistReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .headerIndex(let index):
            return selectHeaderIndex(at: index)
        case .loadPlaylist:
            return fetchPlaylist()
        case .selectTrack(let trackID):
            return fetchTrackData(trackID)
        case .getError(let error):
            return Observable.just(.sendError(error))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .sendHeaderIndex(let index):
            newState.headerIndex = index
        case .setPlayList(let playlist):
            newState.playList = playlist.data
        case .fetchTrackData(let songData):
            newState.trackData = songData.data
        case .sendError(let error):
            newState.error = error
        }
        return newState
    }
}

private extension PlaylistReactor {
    func selectHeaderIndex(at index: Int) -> Observable<Mutation> {
        return Observable<Mutation>.create { observer in
            observer.onNext(.sendHeaderIndex(index))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func fetchPlaylist() -> Observable<Mutation> {
        return Observable<Mutation>.create { observer in
            NetworkAPIManager.fetchPlayList { playlist in
                observer.onNext(.setPlayList(playlist))
                observer.onCompleted()
            } onFailure: { [weak self] error in
                self?.action.onNext(.getError(error))
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func fetchTrackData(_ trackID: Int) -> Observable<Mutation> {
        return Observable<Mutation>.create { observer in
            NetworkAPIManager.fetchTrackData(trackID: trackID) { trackData in
                observer.onNext(.fetchTrackData(trackData))
                observer.onCompleted()
            } onFailure: { [weak self] error in
                self?.action.onNext(.getError(error))
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
