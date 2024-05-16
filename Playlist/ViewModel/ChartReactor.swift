//
//  ChartReactor.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import UIKit
import ReactorKit
import RxCocoa

class ChartReactor: Reactor {
    enum Action {
        case loadChart
        case getTitle(Int)
        case getDesc(Int)
    }
    
    enum Mutation {
        case setChart
        case setTitle(Int)
        case setDesc(Int)
    }
    
    struct State {
        var chartList: [ChartList]?
        var title: NSAttributedString?
        var desc: String?
    }
    
    var initialState: State
    
    init(chartList: [ChartList]) {
        initialState = State()
        initialState.chartList = chartList
    }
}

extension ChartReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadChart:
            return BehaviorRelay<[ChartList]>(value: []).asObservable().map { _ in
                Mutation.setChart
            }
        case .getTitle(let index):
            return BehaviorRelay<NSAttributedString>(value: .init(string: ""))
                .asObservable()
                .map { _ in
                    Mutation.setTitle(index)
                }
        case .getDesc(let index):
            return BehaviorRelay<NSAttributedString>(value: .init(string: ""))
                .asObservable()
                .map { _ in
                    Mutation.setDesc(index)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChart:
            newState.chartList = fetchChart()
        case .setTitle(let index):
            newState.title = combinationTitle(at: index)
        case .setDesc(let index):
            newState.desc = setDesc(at: index)
        }
        return newState
    }
    
    func fetchChart() -> [ChartList]? {
        guard let chartList = initialState.chartList else { return [] }
        return chartList
    }
    
    func combinationTitle(at index: Int) -> NSAttributedString {
        guard let chartList = initialState.chartList else { return .init(string: "") }
        let title = chartList[index].name
        let subTitle = chartList[index].basedOnUpdate
        let totalString = title + " " + subTitle
        let attrSting = NSMutableAttributedString(string: totalString)
        let titleRange = (totalString as NSString).range(of: title)
        let subTitleRange = (totalString as NSString).range(of: subTitle)
        attrSting.addAttributes(
            [
                .font : UIFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor : UIColor.black
            ],
            range: titleRange
        )
        attrSting.addAttributes(
            [
                .font : UIFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor : UIColor.systemGray2
            ],
            range: subTitleRange
        )
        return attrSting
    }
        
    func setDesc(at index: Int) -> String {
        guard let chartList = initialState.chartList else { return "" }
        return chartList[index].description
    }
}
