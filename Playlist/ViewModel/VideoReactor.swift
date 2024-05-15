//
//  VideoReactor.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import Foundation
import ReactorKit

class VideoReactor: Reactor {
    enum Action {
        case loadVideo
    }
    
    enum Mutation {
        case setVideo
    }
    
    struct State {
        var videoPlayList: VideoPlayList?
    }
    
    var initialState: State
    
    init(videoPlayList: VideoPlayList) {
        initialState = State()
        initialState.videoPlayList = videoPlayList
    }
}

extension VideoReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadVideo:
            return PublishSubject<VideoPlayList>().asObservable().map { _ in
                Mutation.setVideo
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setVideo:
            newState.videoPlayList = fetchVideo()
        }
        return newState
    }
    
    func fetchVideo() -> VideoPlayList? {
        guard let videoPlayList = initialState.videoPlayList else { return nil }
        return videoPlayList
    }
}
