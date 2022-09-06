//
//  DetailsVote.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 06/09/2022.
//

import SwiftUI

struct DetailsVote: View {
    var votes: Int
    var voted: Bool
    var action: () -> Void = {}
    var body: some View {
        if votes > 0 {
            HStack {
                Text(votes.formatForDisplay())
                    .font(Font.customFont(.ralewayRegular, size: 18).bold())
                    .foregroundColor(Color.attentionGrabbing)
                Button {
                    action()
                } label: {
                    Image(voted ? "Thumb Up Filled" : "Thumb Up")
                        .tint(.attentionGrabbing)
                }

            }
        } else {
            Button(action: action) {
                Text("Add to playlist")
                    .font(Font.customFont(.ralewayRegular, size: 18).bold())
            }
            .foregroundColor(Color.attentionGrabbing)
        }
    }
}

struct DetailsVote_Previews: PreviewProvider {
    static var previews: some View {
        DetailsVote(votes: 10, voted: true)
    }
}
