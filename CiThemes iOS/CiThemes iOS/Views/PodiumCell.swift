//
//  PodiumCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct PodiumCell: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.background)
                .frame(height: 80, alignment: .center)
            
            HStack {
                Text("2")
            }
            
        }
        .background(.clear)
    }
}

struct PodiumCell_Previews: PreviewProvider {
    static var previews: some View {
        PodiumCell()
    }
}
