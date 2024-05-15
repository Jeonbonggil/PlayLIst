//
//  SectionReactor.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import Foundation
import ReactorKit

final class SectionReactor: Reactor {
    enum Action {
        case loadSection
    }
    
    enum Mutation {
        case setSection
    }
    
    struct State {
        var sectionList: [SectionList]?
    }
    
    var initialState: State
    
    init(sectionList: [SectionList]) {
        initialState = State()
        initialState.sectionList = sectionList
    }
}

extension SectionReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadSection:
            return PublishSubject<[SectionList]>().asObservable().map { _ in
                Mutation.setSection
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSection:
            newState.sectionList = fetchSection()
        }
        return newState
    }
}

extension SectionReactor {
    private func fetchSection() -> [SectionList]? {
        guard let sectionList = initialState.sectionList else { return [] }
        return sectionList
    }
}
