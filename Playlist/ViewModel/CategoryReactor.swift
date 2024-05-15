//
//  CategoryReactor.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import Foundation
import ReactorKit

final class CategoryReactor: Reactor {
    enum Action {
        case loadCategory
    }
    
    enum Mutation {
        case setCategory
    }
    
    struct State {
        var categoryList: ProgramCategoryList?
    }
    
    var initialState: State
    
    init(categoryList: ProgramCategoryList) {
        initialState = State()
        initialState.categoryList = categoryList
    }
    
    var categoryCount: Int {
        return initialState.categoryList?.list.count ?? 0
    }
}

extension CategoryReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadCategory:
            return PublishSubject<ProgramCategoryList>().asObservable().map {
                _ in Mutation.setCategory
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCategory:
            newState.categoryList = fetchCategory()
        }
        return newState
    }
}

extension CategoryReactor {
    func fetchCategory() -> ProgramCategoryList? {
        guard let categoryList = initialState.categoryList else { return nil }
        return categoryList
    }
}
