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
    }
    
    enum Mutation {
        case sendHeaderIndex(Int)
        case setPlayList(PlaylistData)
        case fetchTrackData(TrackData)
    }
    
    struct State {
        var headerIndex: Int?
        var playList: ListData?
        var trackData: SongData?
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
            } onFailure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func fetchTrackData(_ trackID: Int) -> Observable<Mutation> {
        return Observable<Mutation>.create { observer in
            NetworkAPIManager.fetchTrackData(trackID: trackID) { songData in
                observer.onNext(.fetchTrackData(songData))
                observer.onCompleted()
            } onFailure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
