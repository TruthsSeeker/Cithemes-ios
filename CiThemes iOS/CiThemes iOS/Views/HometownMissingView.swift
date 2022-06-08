//
//  HometownMissingView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 07/06/2022.
//

import SwiftUI

struct HometownMissingView: View {
    @EnvironmentObject var userVM: UserViewModel
    var moveToCitySearchAction: ()->()
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            
            if let user = userVM.user {
                VStack {
                    Text("You haven't set a hometown")
                    Text("Do you want to set one now?")
                    Button {
                        moveToCitySearchAction()
                    } label: {
                        Text("Find your city")
                    }

                }
            } else {
                Text("Only logged in users can see their hometown")
            }
        }
    }
}

struct HometownMissingView_Previews: PreviewProvider {
    static var userVM: UserViewModel = {
        var vm = UserViewModel()
        vm.user = User(id: 1, email: "lyraartemish@gmail.com")
        return vm
    }()
    static var previews: some View {
        HometownMissingView(moveToCitySearchAction: {})
            .environmentObject(HometownMissingView_Previews.userVM)
    }
}
