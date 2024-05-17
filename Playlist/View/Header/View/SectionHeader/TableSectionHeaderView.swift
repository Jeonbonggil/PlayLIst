//
//  TableSectionHeaderView.swift
//  Playlist
//
//  Created by Bonggil Jeon on 5/15/24.
//

import UIKit

final class TableSectionHeaderView: UITableViewHeaderFooterView, NibLoadable, ReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
