//
//  PlaylistViewController.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit

final class PlaylistViewController: UIViewController, StoryboardView {
    private struct DrawingConstants {
        static let sectionHeaderHeight = 40.0
    }
    @IBOutlet weak var headerView: PlaylistHeaderView! {
        didSet {
            headerView.headerTitles = sectionTitles
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorInset = .zero
            tableView.separatorStyle = .none
            tableView.sectionHeaderTopPadding = 0
            tableView.register(
                UINib(nibName: TableSectionHeaderView.nibNm, bundle: .main),
                forHeaderFooterViewReuseIdentifier: TableSectionHeaderView.nibNm
            )
            tableView.register(ChartTableCell.self)
            tableView.register(SectionTableCell.self)
            tableView.register(CategoryTableCell.self)
            tableView.register(VideoTableCell.self)
        }
    }
    private let sectionTitles = ["차트", "장르/테마", "오디오", "비디오"]
    var reactor = PlaylistReactor()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: reactor)
        reactor.action.onNext(.loadPlaylist)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bind(reactor: PlaylistReactor) {
        reactor.state
            .map { $0.playList }
            .filter { $0 != nil }
            .subscribe { [weak self] list in
                print("Playlist Data: \(String(describing: list))")
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.songData }
            .filter { $0 != nil }
            .subscribe { [weak self] songData in
                print("Song Data: \(String(describing: songData))")
            }
            .disposed(by: disposeBag)
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard SectionType.allCases[section] != .sectionList else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TableSectionHeaderView.nibNm
        ) as? TableSectionHeaderView
        view?.configure(title: sectionTitles[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DrawingConstants.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playlistData else { return 0 }
        let sectionType = SectionType.allCases[section]
        switch sectionType {
        case .rankChart:
            return playlistData.chartListCount
        case .sectionList:
            return playlistData.sectionListCount
        case .categoryList, .videoList:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionType.allCases[indexPath.section]
        switch sectionType {
        case .rankChart:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartTableCell
            cell.selectionStyle = .none
            return cell
        case .genreNTheme:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartTableCell
            cell.selectionStyle = .none
            return cell
        case .audio:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartTableCell
            cell.selectionStyle = .none
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartTableCell
            cell.selectionStyle = .none
            return cell
        }
        
    }
}
