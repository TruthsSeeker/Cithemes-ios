//
//  FirstRankTableViewCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 02/01/2022.
//

import Foundation
import UIKit

class FirstRankTableViewCell: RankingTableViewCell {
    @IBOutlet var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let uppercaseAttribs = [
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberCaseType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseNumbersSelector
        ]

        let fontAttribs: [UIFontDescriptor.AttributeName : Any] = [
            UIFontDescriptor.AttributeName.name: "Raleway-Medium",
            UIFontDescriptor.AttributeName.featureSettings: [uppercaseAttribs]
        ]

        let descriptor = UIFontDescriptor(fontAttributes: fontAttribs)
        let liningRaleway = UIFont(descriptor: descriptor, size: 32.0)
        rankLabel.font = liningRaleway
        
        background.layer.cornerRadius = 6
        background.layer.borderColor = UIColor(named: "Relief")?.cgColor
        background.layer.borderWidth = 1
    }
}
