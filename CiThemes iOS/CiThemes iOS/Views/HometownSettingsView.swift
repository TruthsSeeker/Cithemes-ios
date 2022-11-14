//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 20/10/2022.
//

import SwiftUI

struct HometownSettingsView: View {
    @EnvironmentObject var coordinator: RootCoordinator
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 12) {
                Text("Current Hometown")
                    .font(Font.customFont(.openSans, size: 32))
                
                //TODO: Link to homepage
                HStack(alignment: .top) {
                    RemoteImage(coordinator.hometown?.image)
                        .frame(width: 90, height: 90)
                        .cornerRadius(8)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(coordinator.hometown?.name ?? "Los Angeles")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.customFont(.ralewayRegular, size: 24))
                            .foregroundColor(Color.fontMain)
                        Text(coordinator.hometown?.country ?? "USA")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.customFont(.ralewayRegular, size: 18))
                            .foregroundColor(Color.fontSecondary)
                    }
                }
                Text("Last updated on")
                    .font(Font.customFont(.openSans, size: 28))
                
                Text(coordinator.hometown?.lastUpdate
                    .formatted(date:.complete, time: .omitted)
                     ?? Date().formatted(date:.complete, time: .omitted))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.customFont(.ralewayRegular, size: 18))
                    .foregroundColor(Color.fontMain)
                
                //TODO: Calculate and display change date
                Text("You will be able to change it again a month after this date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.customFont(.ralewayRegular, size: 18))
                    .foregroundColor(Color.fontMain)
                Spacer()
            }
            .padding(16)
            
        }
    }
}

struct HometownSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HometownSettingsView()
            .environmentObject(RootCoordinator())
    }
}
