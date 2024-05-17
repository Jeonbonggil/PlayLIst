//
//  ChartTableCell.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

protocol ChartTableCellDelegate: AnyObject {
    func didSelectItemWithTrackID(_ trackID: Int)
}

final class ChartTableCell: UITableViewCell, StoryboardView, NibLoadable, ReusableView {
    private struct DrawingConstants {
        static let size = CGSize(width: width, height: height)
        static let width = ChartTableCell().screen?.bounds.width ?? 0
        static let height = 360.0
        static let footerHeight = 30.0
        static let footerSize = CGSize(width: width, height: footerHeight)
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(ChartItemCell.self)
            collectionView.registerFooterForClass(ChartFooterView.self)
            collectionView.collectionViewLayout = compositionalLayout()
        }
    }
    private var chartList: ChartList?
    private let currentPage = PublishSubject<Int>()
    private let cellCount = 5
    var index = 0
    var delegate: ChartTableCellDelegate?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        collectionView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: ChartReactor) {
        reactor.action.onNext(.getTitle(index))
        reactor.action.onNext(.getDesc(index))
        
        reactor.state
            .map { $0.chartList }
            .compactMap { $0 }
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] list in
                guard let self else { return }
                chartList = list[index]
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.title }
            .take(1)
            .observe(on: MainScheduler.instance)
            .bind(to: title.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.desc }
            .take(1)
            .observe(on: MainScheduler.instance)
            .bind(to: desc.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ChartTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ChartFooterView.nibNm,
            for: indexPath
        ) as! ChartFooterView
        guard let chartList else { return view }
        let pageCount = (chartList.trackCount / cellCount) +
        (chartList.trackCount % cellCount == 0 ? 0 : 1)
        view.bind(input: currentPage, indexPath: indexPath, pageNumber: pageCount)
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return chartList?.trackCount ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ChartItemCell
        guard let list = chartList?.trackList?[safe: indexPath.row] else { return cell }
        cell.configureCell(at: indexPath.row, list)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let list = chartList?.trackList?[safe: indexPath.row] else { return }
        delegate?.didSelectItemWithTrackID(list.id)
    }
}

//MARK: - UICollectionViewCompositionalLayout

extension ChartTableCell {
    private func compositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            // item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 12,
                leading: 15,
                bottom: 12,
                trailing: 15
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.9)
            )
            // group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitem: item,
                count: 5
            )
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 5,
                bottom: 0,
                trailing: 5
            )
            section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                let posY = round(contentOffset.x / environment.container.contentSize.width)
                let bannerIndex = Int(max(0, posY))
                self?.currentPage.onNext(bannerIndex)
            }
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(30)
                ),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            section.boundarySupplementaryItems = [sectionFooter]
            return section
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChartTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return DrawingConstants.footerSize
    }
}
