//
//  ChartFooterView.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class FooterView: UICollectionReusableView {
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(input: Observable<Int>, indexPath: IndexPath, pageNumber: Int) {
        pageControl.numberOfPages = pageNumber
        if indexPath.section == 1 {
            self.isHidden = true
        } else {
            input
                .subscribe { [weak self] currentPage in
                    self?.pageControl.currentPage = currentPage
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func configureUI() {
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
