//
//  TrackDetailReactor.swift
//  Playlist
//
//  Created by ec-jbg on 5/16/24.
//

import Foundation
import ReactorKit

final class TrackDetailReactor: Reactor {
    enum Action {
        case getSongName
        case getArtistName
        case getLyrics
        case getLyricsViewTop
    }
    
    enum Mutation {
        case setSongName
        case setArtistName
        case setLyrics
        case setLyricsViewTop
    }
    
    struct State {
        var trackData: SongData?
        var songName: String?
        var artistName: String?
        var lyrics: String?
        var lyricsViewTopConst: CGFloat?
    }
    
    var initialState: State
    
    init(trackData: SongData) {
        initialState = State()
        initialState.trackData = trackData
    }
}

extension TrackDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getSongName:
            return Observable.just(Mutation.setSongName)
        case .getArtistName:
            return Observable.just(Mutation.setArtistName)
        case .getLyrics:
            return Observable.just(Mutation.setLyrics)
        case .getLyricsViewTop:
            return Observable.just(Mutation.setLyricsViewTop)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSongName:
            newState.songName = newState.trackData?.name
        case .setArtistName:
            newState.artistName = newState.trackData?.artistName
        case .setLyrics:
            newState.lyrics = newState.trackData?.lyrics
        case .setLyricsViewTop:
            newState.lyricsViewTopConst = newState.trackData?.lyrics?.isEmpty ?? true ? 100 : 0
        }
        return newState
    }
}
