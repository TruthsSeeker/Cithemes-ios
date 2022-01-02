//
//  PodiumRankTableViewCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 02/01/2022.
//

import UIKit

class PodiumRankTableViewCell: RankingTableViewCell {
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
        let liningRaleway = UIFont(descriptor: descriptor, size: 24.0)
        rankLabel.font = liningRaleway
    }
}
