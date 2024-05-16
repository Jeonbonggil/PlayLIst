//
//  Label.swift
//  Playlist
//
//  Created by ec-jbg on 5/13/24.
//

import UIKit

extension UILabel {
    func addAttributeText(
        fullString: String,
        font: UIFont? = nil,
        addStrings: [String],
        addFont: UIFont? = nil,
        color: UIColor? = nil
    ) {
        guard fullString.count > 0 else { return }
        let nonBoldFont: UIFont = font ?? .systemFont(ofSize: self.font.pointSize)
        let nonBoldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: nonBoldFont,
            .foregroundColor: color ?? .systemGray2
        ]
        let boldFont: UIFont = addFont ?? .boldSystemFont(ofSize: self.font.pointSize)
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: boldFont,
            .foregroundColor: UIColor.black
        ]
        let boldString = NSMutableAttributedString(
            string: fullString,
            attributes: nonBoldFontAttribute
        )
        let fString = NSString(string: fullString.uppercased())
        for bString in addStrings {
            let range = fString.range(of: bString.uppercased())
            boldString.addAttributes(boldFontAttribute, range: range)
        }
        attributedText = boldString
    }
    
    func addAttributeString(
        fullString: String,
        font: UIFont? = nil,
        addStrings: [String],
        addFont: UIFont? = nil,
        color: UIColor? = .black
    ) {
        guard fullString.count > 0 else { return }
        let boldFont: UIFont = font ?? .boldSystemFont(ofSize: self.font.pointSize)
        let boldFontAttribute: [NSAttributedString.Key : Any] = [.font : boldFont, .foregroundColor: UIColor.black]
        let nonBoldFont: UIFont = addFont ?? .systemFont(ofSize: self.font.pointSize)
        let nonBoldFontAttribute: [NSAttributedString.Key : Any] = [.font : nonBoldFont, .foregroundColor: color ?? .black]
        
        let attrString = NSMutableAttributedString(string: fullString)
        let fString = NSString(string: fullString.uppercased())
        let range1 = fString.range(of: addStrings[safe: 0]?.uppercased() ?? "")
        let range2 = fString.range(of: "/\(addStrings[safe: 1]?.uppercased() ?? "")")
        attrString.addAttributes(boldFontAttribute, range: range1)
        attrString.addAttributes(nonBoldFontAttribute, range: range2)
        attributedText = attrString
    }
}
