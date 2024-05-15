//
//  VideoItemCell.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/14/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture
/**
 ## 설명
 * <# 요약 #>
 
 ## 기본정보
 * Note: APP
 * See: <# 제플린 없음 #>
 */
class VideoItemCell: UICollectionViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var playTimeBgView: UIView!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 4
        playTimeBgView.layer.cornerRadius = 4
    }
    
    func configureCell(_ list: VideoList?) {
        guard let list else { return }
        thumbnail.kf.setImage(with: list.thumbnailURL)
        playTime.text = list.playTm
        songTitle.text = list.videoNm
        artistName.text = list.artistName
    }
}

