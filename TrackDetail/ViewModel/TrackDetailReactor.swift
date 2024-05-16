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
        case loadTrackDetail
    }
    
    enum Mutation {
        case setTrackDetail(TrackData)
    }
    
    struct State {
        var trackData: TrackData?
    }
    
    let initialState: State = State()
}

extension TrackDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadTrackDetail:
            return PublishSubject<TrackData>().asObservable().map { songData in
                Mutation.setTrackDetail(songData)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTrackDetail(let songData):
            newState.trackData = songData
        }
        return newState
    }
    
    func fetchTrackDetail() -> TrackData? {
        guard let trackDetail = initialState.trackData else { return nil }
        return trackDetail
    }
}
