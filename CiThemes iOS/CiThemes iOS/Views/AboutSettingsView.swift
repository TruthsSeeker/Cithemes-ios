//
//  AboutSettingsView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 14/11/2022.
//

import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Contact Us")
                    .font(Font.customFont(.openSans, size: 28))
                
                Link("support@cithemes.com", destination: URL(string: "mailto:support@cithemes.com")!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.customFont(.ralewayRegular, size: 18))
                    .foregroundColor(Color.fontMain)
                
                Text("Data usage Policy")
                    .font(Font.customFont(.openSans, size: 28))
                Text("We use your email as account name, that's it")
                Spacer()
                
            }
            .padding(16)
        }
    }
}

struct AboutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingsView()
    }
}
