//
//  ChartItemCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/14/24.
//

import UIKit
import RxSwift
import RxCocoa
/**
 ## 설명
 * <# 요약 #>
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class ChartItemCell: UICollectionViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 60
            tableView.register(ChartItemListCell.self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChartItemCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChartItemListCell
        let index = indexPath.row
        cell.configureCell(index)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


