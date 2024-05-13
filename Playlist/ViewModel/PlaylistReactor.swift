//
//  PlaylistReactor.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import RxSwift
import ReactorKit

class PlaylistReactor: Reactor {
    enum Action {
        case loadPlaylist(PlaylistData)
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
        case .loadPlaylist(let playlist):
            return Observable.just(Mutation.setPlayList(playlist))
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
    @MainActor
    private func fetchPlaylist() -> Observable<Mutation> {
        return Observable<Mutation>.create { observer in
            Task {
                let playlist = try await NetworkAPIManager.fetchPlayList()
                observer.onNext(.setPlayList(playlist))
                observer.onCompleted()
            }
//            print("fetchPlaylist Error: \(error)")
//            observer.onError(error)
            return Disposables.create()
        }
    }
}
