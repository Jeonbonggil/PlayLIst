//
//  GenreItemCell.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import UIKit
import Kingfisher

/**
 ## 설명
 * <# 요약 #>
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class GenreItemCell: UICollectionViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var genreName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        
    }
}

