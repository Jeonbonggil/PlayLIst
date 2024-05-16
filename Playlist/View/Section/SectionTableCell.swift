//
//  GenreTableCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/14/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
/**
 ## 설명
 * Shortcut Section Table Cell
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class SectionTableCell: UITableViewCell, StoryboardView, ReusableView, NibLoadable {
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
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    private var sectionList: SectionList?
    var index = 0
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: SectionReactor) {
        reactor.state
            .map { $0.sectionList }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] list in
                guard let self, let list = list.element?.flatMap({ $0 }) else { return }
                sectionList = list[index]
                typeName.text = sectionList?.name
                let count = sectionList?.shortcutCount ?? 0
                calculateCollectionViewHeight(count)
                collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func calculateCollectionViewHeight(_ count: Int) {
        collectionViewHeightConst.constant =
        DrawingConstants.height * (Double(count / 2) + (count % 2 == 0 ? 0 : 1)) +
        DrawingConstants.spacing * (Double(count / 2) + (count % 2 == 0 ? 0 : 1))
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SectionTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sectionList?.shortcutCount ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SectionItemCell
        guard let list = sectionList?.shortcutList?[indexPath.row] else { return cell}
        cell.configureCellForShortcut(list)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SectionTableCell: UICollectionViewDelegateFlowLayout {
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
