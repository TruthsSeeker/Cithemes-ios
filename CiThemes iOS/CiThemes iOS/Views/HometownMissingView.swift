//
//  HometownMissingView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 07/06/2022.
//

import SwiftUI

struct HometownMissingView: View {
    @EnvironmentObject var coordinator: TabCoordinator
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            
            if coordinator.userViewModel.user != nil {
                VStack {
                    Text("You haven't set a hometown")
                    Text("Do you want to set one now?")
                    StyledButton(title: "Find your hometown") {
                        coordinator.tab = .search
                    }

                }
            } else {
                VStack {
                    Text("Only logged in users can see their hometown")
                    StyledButton(title: "Login/Sign Up") {
                        coordinator.showSignUp.toggle()
                    }
                }

            }
        }
    }
}

struct HometownMissingView_Previews: PreviewProvider {
    static var previews: some View {
        HometownMissingView()
            .environmentObject(TabCoordinator())
    }
}
