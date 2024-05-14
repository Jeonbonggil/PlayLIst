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

class PlaylistViewController: UIViewController, View {
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
//            tableView.register(UITableViewCell.self)
        }
    }
    var reactor = PlaylistReactor()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: reactor)
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
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Playlist"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(for: indexPath) as UITableViewCell
//        cell.selectionStyle = .none
//        return cell
        return UITableViewCell()
    }
}
