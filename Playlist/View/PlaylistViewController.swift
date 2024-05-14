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
            tableView.register(ChartTableCell.self)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SectionType.allCases[section]
        switch sectionType {
        case .rankChart:
            return 1
        case .genreNTheme:
            return 1
        case .audio:
            return 1
        case .video:
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
