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
        case selectSongData(SongData)
    }
    
    enum Mutation {
        case sendHeaderIndex(Int)
        case setPlayList(PlaylistData)
        case fetchSongData(SongData)
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
        case .selectSongData(let songData):
            return Observable.just(Mutation.fetchSongData(songData))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .sendHeaderIndex(let index):
            newState.headerIndex = index
        case .setPlayList(let playlist):
            newState.playList = playlist.data
        case .fetchSongData(let songData):
            newState.trackData = songData
        
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
    
    func fetchSongData(trackId: String) -> Observable<Mutation> {
        return Observable<Mutation>.create { observer in
            NetworkAPIManager.fetchSongData(trackID: trackId) { songData in
                observer.onNext(.fetchSongData(songData))
                observer.onCompleted()
            } onFailure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
