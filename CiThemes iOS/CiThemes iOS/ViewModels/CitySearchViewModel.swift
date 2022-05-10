//
//  CitySearchViewModel.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import Foundation
import Combine

final class CitySearchViewModel: ObservableObject {
    @Published var city: City = City(country: "United States of America", countryISO: "US", name: "Los Angeles")
    @Published var searchTerms: String?
    private var searchPublisher: AnyPublisher<[City], Error>?
    
    func search() {
        
    }
}
