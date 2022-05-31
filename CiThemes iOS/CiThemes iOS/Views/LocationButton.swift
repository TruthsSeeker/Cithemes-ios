//
//  LocationButton.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 31/05/2022.
//

import SwiftUI
import CoreLocation
import Combine

struct LocationButton: View {
    let action: (CLLocation) -> ()
    
    @StateObject
    private var locationProvider = LocationProvider()
    
    var body: some View {
        Button {
            print("pressed")
            locationProvider.requestLocation()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30, alignment:.center)
                    .foregroundColor(.relief)
                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                Image(systemName: "location.fill")
                    .foregroundColor(Color.fontAlwaysLight)
            }
        }.onReceive(locationProvider.$location) { location in
            guard let location = location else { return }
            action(location)
        }
    }
}

struct LocationButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationButton { _ in }
    }
}
