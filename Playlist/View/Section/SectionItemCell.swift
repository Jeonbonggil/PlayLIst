//
//  GenreItemCell.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import UIKit
import Kingfisher
import ReactorKit
/**
 ## 설명
 * Shortcut, Category의 리스트 Cell
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
final class SectionItemCell: UICollectionViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var genreName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgImage.layer.cornerRadius = 10
    }
    
    func configureCellForShortcut(_ list: ShortcutList?) {
        guard let list else { return }
        bgImage.kf.setImage(with: list.imgListURL)
        genreName.text = list.name
    }
    
    func configureCellForCategory(_ list: List?) {
        guard let list else { return }
        bgImage.kf.setImage(with: list.imgListURL)
        genreName.text = list.displayTitle
    }
}

