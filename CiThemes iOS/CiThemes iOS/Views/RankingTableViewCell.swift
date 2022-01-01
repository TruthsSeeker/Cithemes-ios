//
//  RankingTableViewCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/07/2021.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var voteStack: UIStackView!
    @IBOutlet weak var voteLabel: UILabel!
    
    var voteTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let uppercaseAttribs = [
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberCaseType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseNumbersSelector
        ]

        let fontAttribs: [UIFontDescriptor.AttributeName : Any] = [
            UIFontDescriptor.AttributeName.name: "Raleway-Medium",
            UIFontDescriptor.AttributeName.featureSettings: [uppercaseAttribs]
        ]

        let descriptor = UIFontDescriptor(fontAttributes: fontAttribs)
        let liningRaleway = UIFont(descriptor: descriptor, size: 18.0)
        rankLabel.font = liningRaleway
        voteLabel.font = liningRaleway
        
        voteTapRecognizer.addTarget(self, action: #selector(voteTapped))
        voteStack.addGestureRecognizer(voteTapRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func voteTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
}
