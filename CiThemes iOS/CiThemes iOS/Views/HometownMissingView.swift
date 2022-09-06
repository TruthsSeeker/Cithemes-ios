//
//  HometownMissingView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 07/06/2022.
//

import SwiftUI

struct HometownMissingView: View {
    @EnvironmentObject var coordinator: RootCoordinator
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            
            if coordinator.userViewModel.user != nil {
                VStack {
                    Text("You haven't set a hometown")
                        .font(.custom("RalewayDots-Regular", size: 32))
                        .foregroundColor(Color.fontMain)
                        .multilineTextAlignment(TextAlignment.center)
                    Text("Do you want to set one now?")
                        .font(.custom("RalewayDots-Regular", size: 32))
                        .foregroundColor(Color.fontMain)
                        .multilineTextAlignment(TextAlignment.center)
                    StyledButton(title: "Find your hometown") {
                        coordinator.tab = .search
                    }

                }
            } else {
                VStack {
                    Text("Only logged in users can see their hometown")
                        .font(.custom("RalewayDots-Regular", size: 32))
                        .foregroundColor(Color.fontMain)
                        .multilineTextAlignment(TextAlignment.center)
                    StyledButton(title: "Login/Sign Up") {
                        coordinator.showSignUp.toggle()
                    }
                }

            }
        }
    }
}

struct HometownMissingView_Previews: PreviewProvider {
    static var userCoordinator: RootCoordinator = {
       let coordinator = RootCoordinator()
        coordinator.userViewModel = UserViewModel(coordinator: coordinator)
        coordinator.userViewModel.user = User.init(id: 0, email: "", hometownId: nil, username: nil)
        return coordinator
    }()
    static var previews: some View {
        HometownMissingView()
            .environmentObject(RootCoordinator())
        HometownMissingView()
            .environmentObject(userCoordinator)
    }
}
