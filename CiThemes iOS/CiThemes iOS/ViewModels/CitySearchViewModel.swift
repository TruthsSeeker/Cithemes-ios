//
//  CitySearchViewModel.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import Foundation
import Combine
import CoreLocation

final class CitySearchViewModel: ObservableObject {
    @Published var city: City = City(country: "United States of America", iso2: "US", name: "Los Angeles", population: 0)
    @Published var searchTerms: String = ""
    @Published var results: [City] = []
    private var searchPublisher: AnyCancellable?
    
    func searchByName() {
        guard let urlPath = URL.getUrl(for: "/cities/find") else {
            return
        }
        var urlParams = URLComponents(url: urlPath, resolvingAgainstBaseURL: true)
        urlParams?.queryItems = [URLQueryItem(name: "query", value: searchTerms)]
        
        guard let url = urlParams?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        searchPublisher = searchPublisher(request)
    }
    
    func findNearest(withLocation location: CLLocation) {
        guard
            let url = URL.getUrl(
                for: "/cities/nearest/\(location.coordinate.latitude)/\(location.coordinate.longitude)")
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        searchPublisher = searchPublisher(request)
    }
    
    fileprivate func searchPublisher(_ request: URLRequest) -> AnyCancellable {
        return NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<[City]>.self)
            .receive(on: DispatchQueue.main)
            .map(\.result)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                case .finished:
                    break
                }
            }, receiveValue: { cities in
                guard let biggest = cities.max(by: { a, b in
                    a.population < b.population
                }) else {
                    self.results = []
                    return
                }
                let smaller = cities.filter({$0.id != biggest.id})
                let ordered = [biggest] + smaller
                self.results = ordered
            })
    }
}
