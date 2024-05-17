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
            tableView.prefetchDataSource = self
            tableView.separatorInset = .zero
            tableView.separatorStyle = .none
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.sectionHeaderHeight = 0
            tableView.sectionFooterHeight = 0
            tableView.registerHeaderFooter(TableSectionHeaderView.self)
            tableView.register(ChartTableCell.self)
            tableView.register(SectionTableCell.self)
            tableView.register(CategoryTableCell.self)
            tableView.register(VideoTableCell.self)
        }
    }
    private let sectionTitles = ["차트", "장르/테마", "오디오", "영상"]
    private var mainReactor = PlaylistReactor()
    private var chartReactor: ChartReactor?
    private var sectionReactor: SectionReactor?
    private var categoryReactor: CategoryReactor?
    private var videoReactor: VideoReactor?
    private var playlistData: ListData?
    private var cellHeightsDictionary = [String: CGFloat]()
    var disposeBag = DisposeBag()
    
    func bind(reactor: PlaylistReactor) {
        headerView.reactor = reactor
        
        reactor.state
            .map { $0.headerIndex }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] index in
                guard let self, let section = index.element?.flatMap({ $0 }) else { return }
                let indexPath = IndexPath(row: 0, section: section)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                headerView.isScrolling = false
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.playList }
            .filter { $0 != nil }
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] list in
                guard let self, let data = list.element?.flatMap({ $0 }) else { return }
                playlistData = data
                chartReactor = ChartReactor(chartList: data.chartList)
                sectionReactor = SectionReactor(sectionList: data.sectionList)
                categoryReactor = CategoryReactor(categoryList: data.programCategoryList)
                videoReactor = VideoReactor(videoPlayList: data.videoPlayList)
                tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.trackData }
            .filter { $0 != nil }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] trackData in
                guard let self, let trackData = trackData.element?.flatMap({ $0 }) else { return }
                let trackVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(identifier: TrackDetailViewController.ID) { creator in
                        guard let vc = TrackDetailViewController(
                            trackData: trackData,
                            coder: creator
                        ) else {
                            return UIViewController()
                        }
                        return vc
                    }
                present(trackVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Life Cycle

extension PlaylistViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: mainReactor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainReactor.action.onNext(.loadPlaylist)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//MARK: - ChartTableCellDelegate

extension PlaylistViewController: ChartTableCellDelegate {
    func didSelectItemWithTrackID(_ trackID: Int) {
        mainReactor.action.onNext(.selectTrack(trackID))
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

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
        let sectionType = SectionType.allCases[section]
        guard sectionType != .sectionList else { return 0 }
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
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        return cellHeightsDictionary[indexPath.estimatedHeightKey] = cell.frame.size.height
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return cellHeightsDictionary[indexPath.estimatedHeightKey] ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionType.allCases[indexPath.section]
        switch sectionType {
        case .rankChart:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartTableCell
            cell.index = indexPath.row
            cell.reactor = chartReactor
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .sectionList:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SectionTableCell
            cell.index = indexPath.row
            cell.reactor = sectionReactor
            cell.selectionStyle = .none
            return cell
        case .categoryList:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryTableCell
            cell.reactor = categoryReactor
            cell.selectionStyle = .none
            return cell
        case .videoList:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as VideoTableCell
            cell.reactor = videoReactor
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension PlaylistViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            prefetchCellData(indexPath)
        }
    }
    
    func prefetchCellData(_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: indexPath.section)
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                let sectionType = SectionType.allCases[indexPath.section]
                switch sectionType {
                case .rankChart:
                    let cell = self.tableView.cellForRow(at: indexPath) as! ChartTableCell
                    cell.reactor = self.chartReactor
                    let indexSet = IndexSet(integer: indexPath.section)
                    self.tableView.reloadSections(indexSet, with: .top)
                case .sectionList:
                    let cell = self.tableView.cellForRow(at: indexPath) as! SectionTableCell
                    cell.reactor = self.sectionReactor
                    let indexSet = IndexSet(integer: indexPath.section)
                    self.tableView.reloadSections(indexSet, with: .top)
                case .categoryList:
                    let cell = self.tableView.cellForRow(at: indexPath) as! CategoryTableCell
                    cell.reactor = self.categoryReactor
                    let indexSet = IndexSet(integer: indexPath.section)
                    self.tableView.reloadSections(indexSet, with: .top)
                case .videoList:
                    let cell = self.tableView.cellForRow(at: indexPath) as! VideoTableCell
                    cell.reactor = self.videoReactor
                    let indexSet = IndexSet(integer: indexPath.section)
                    self.tableView.reloadSections(indexSet, with: .top)
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PlaylistViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows,
           let firstIndexPath = indexPaths.first, headerView.isScrolling {
            let section = firstIndexPath.section
            headerView.selectedIndex = section
            headerView.collectionView.reloadData()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows,
           let firstIndexPath = indexPaths.first, !headerView.isScrolling {
            let section = firstIndexPath.section
            headerView.selectedIndex = section
            headerView.collectionView.reloadData()
            headerView.isScrolling = true
        }
    }
}
