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
import RxGesture

class ChartTableCell: UITableViewCell, StoryboardView, NibLoadable, ReusableView {
    private enum SupplementaryKind {
        static let header = "header-element-kind"
        static let footer = "footer-element-kind"
    }
    private struct DrawingConstants {
        static let size = CGSize(width: width, height: height)
        static let width = ChartTableCell().screen?.bounds.width ?? 0
        static let height = 300.0
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellNibForClass(ChartItemCell.self)
            collectionView.collectionViewLayout = compositionalLayout()
            let cellWidth = DrawingConstants.width
            let cellHeight = DrawingConstants.height
            let insetX = (collectionView.bounds.width - cellWidth) / 2.0
            let insetY = (collectionView.bounds.height - cellHeight) / 2.0
            collectionView.contentInset = UIEdgeInsets(
                top: insetY,
                left: insetX,
                bottom: insetY,
                right: insetX
            )
            collectionView.decelerationRate = .fast
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = 4
            pageControl.currentPage = 0
        }
    }
    private let currentBannerPage = PublishSubject<Int>()
    var reactor: ChartReactor?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let reactor else { return }
        bind(reactor: reactor)
    }
    
    func bind(reactor: ChartReactor) {
        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .bind(to: title.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.desc }
            .distinctUntilChanged()
            .bind(to: desc.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ChartTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
//        return reactor?.chartCount ?? 0
        return 20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ChartItemCell
        cell.configureCell(at: indexPath.row, reactor)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("didSelect: \(indexPath.row)")
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
                heightDimension: .fractionalHeight(1.0)
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
            section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                // 비교용 - Device의 Screen 크기
                print("=== Screen Width/Height :", UIScreen.main.bounds.width, "/", UIScreen.main.bounds.height)
                // ✅ contentOffset은 CollectionView의 bound를 기준으로 Scroll 결과 보여지는 컨텐츠의 Origin을 나타냄
                // 배너 및 목록화면의 경우, Scroll하면 어디서 클릭해도 0부터 시작
                // 상세화면의 경우, Scroll하면 어디서 클릭해도 약 -30부터 시작 (기기마다 다름, CollectionView의 bound를 기준으로 cell(이미지)의 leading이 왼쪽 (-30)에 위치하므로 음수임)
                print("OffsetX :", contentOffset.x)

                // ✅ environmnet는 collectionView layout 관련 정보를 담고 있음
                // environment.container.contentSize는 CollectionView 중에서 현재 Scroll된 Group이 화면에 보이는 높이를 나타냄
                print("environment Width :", environment.container.contentSize.width)   // Device의 스크린 너비와 동일
                print("environment Height :", environment.container.contentSize.height) // Horizontal Scroll하면 스크린 너비와 같고, Vertical Scroll하면 그보다 커짐

                let bannerIndex = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))  // 음수가 되는 것을 방지하기 위해 max 사용
                if environment.container.contentSize.height == environment.container.contentSize.width {  // ❗Horizontal Scroll 하는 조건
                    self?.currentBannerPage.onNext(bannerIndex)  // 클로저가 호출될 때마다 pageControl의 currentPage로 값을 보냄
                }
            }
            
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                ),
                elementKind: SupplementaryKind.footer,
                alignment: .bottom
            )
            section.boundarySupplementaryItems = [sectionFooter]
            return section
        }
    }
}
