//
//  PlaylistReactor.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import RxSwift
import ReactorKit

enum SectionType: String, CaseIterable {
    case rankChart
    case genreNTheme
    case audio
    case video
}

class PlaylistReactor: Reactor {
    enum Action {
        case loadPlaylist
        case selectSongData(SongData)
    }
    
    enum Mutation {
        case setPlayList(PlaylistData)
        case fetchSongData(SongData)
    }
    
    struct State {
        var playList: PlaylistData?
        var songData: SongData?
    }
    
    let initialState: State = State()
}

extension PlaylistReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadPlaylist:
            return fetchPlaylist()
        case .selectSongData(let songData):
            return Observable.just(Mutation.fetchSongData(songData))
        }
    }
}
    
extension PlaylistReactor {
    func reduce(state: State, mutate: Mutation) -> State {
        var newState = state
        switch mutate {
        case .setPlayList(let playlist):
            newState.playList = playlist
        case .fetchSongData(let songData):
            newState.songData = songData
        }
        return newState
    }
}

extension PlaylistReactor {
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
    
    func fetchSongData() {
        
    }
}
