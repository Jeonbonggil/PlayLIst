//
//  ChartReactor.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import Foundation
import ReactorKit
import RxCocoa

class ChartReactor: Reactor {
    enum Action {
        case loadChart
    }
    
    enum Mutation {
        case setChart([ChartList])
    }
    
    struct State {
        var chartList: [ChartList]?
        var title: String?
        var desc: String?
    }
    
    var initialState: State
    
    init(chartList: [ChartList]) {
        initialState = State()
        initialState.chartList = chartList
    }
    
    var chartCount: Int {
        return currentState.chartList?.count ?? 0
    }
}

extension ChartReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadChart:
            return BehaviorRelay<[ChartList]>(value: []).asObservable().map { _ in
                Mutation.setChart([])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChart:
            newState.chartList = fetchChart()
            newState.title = initialState.chartList?.first?.name
            newState.desc = initialState.chartList?.first?.description
        }
        return newState
    }
    
    func fetchChart() -> [ChartList] {
        return State().chartList ?? []
    }
}
