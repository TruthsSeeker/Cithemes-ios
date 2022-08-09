//
//  CitySearchResult.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import SwiftUI

struct CitySearchResult: View {
    @State var city: CityModel
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 120, alignment: .center)
            .foregroundColor(Color.background)
            HStack(alignment: .top) {
                RemoteImage(city.image, placeholder: Image("LosAngeles"))
                    .frame(width: 90, height: 90, alignment: .center)
                    .cornerRadius(8)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(city.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.ralewayRegular, size: 18))
                        .foregroundColor(Color.fontMain)
                    Text(city.country)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.ralewayRegular, size: 16))
                        .foregroundColor(Color.fontSecondary)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            
            
        }
    }
}

struct CitySearchResult_Previews: PreviewProvider {
    static var previews: some View {
        CitySearchResult(city: CityModel(country: "United States of America", iso2: "US", name: "Los Angeles", population: 0))
    }
}
