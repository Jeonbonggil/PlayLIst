//
//  CategoryTableCell.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/15/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
/**
 ## 설명
 * 카테고리 Cell
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class CategoryTableCell: UITableViewCell, StoryboardView, ReusableView, NibLoadable {
    private struct DrawingConstants {
        static let size = CGSize(width: width, height: height)
        static let width = (SectionTableCell().screen?.bounds.width ?? 0) / 2 - inset.left - spacing / 2
        static let inset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let spacing = 15.0
        static let height = 86.0
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(SectionItemCell.self)
        }
    }
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    var reactor: CategoryReactor? {
        didSet {
            guard let reactor else { return }
            bind(reactor: reactor)
        }
    }
    private var categoryList: [List]?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(reactor: CategoryReactor) {
        reactor.state
            .map { $0.categoryList }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] list in
                guard let self, let list = list.element?.flatMap({ $0 })?.list else { return }
                categoryList = list
                let count = list.count
                collectionViewHeightConst.constant =
                DrawingConstants.height * (Double(count / 2) +
                (count % 2 == 0 ? 0 : 1)) +
                DrawingConstants.spacing * Double(count / 2)
                collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CategoryTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return categoryList?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SectionItemCell
        guard let list = categoryList?[safe: indexPath.row] else { return UICollectionViewCell() }
        cell.configureCellForCategory(list)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoryTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return DrawingConstants.size
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DrawingConstants.spacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DrawingConstants.spacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return DrawingConstants.inset
    }
}
