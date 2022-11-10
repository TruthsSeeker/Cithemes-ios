//
//  RemoteImage.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 25/01/2022.
//

import SwiftUI
import Combine

struct RemoteImage: View {
    @ObservedObject fileprivate var loader: ImageLoader
    var placeholder: Image?
    
    init(_ url: URL?, placeholder: Image? = Image("placeholder")) {
        loader = ImageLoader(url)
        self.placeholder = placeholder
    }
    
    @ViewBuilder
    var body: some View {
        if let data = loader.data, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else if let placeholder = placeholder {
            placeholder
                .resizable()
                .scaledToFill()
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(URL(string: "www.example.com"), placeholder: Image("LosAngeles"))
    }
}

fileprivate class ImageLoader: ObservableObject {
    @Published var data: Data?
    
    init(_ url: URL?) {
        // Only load if the url is valid and doesn't refer to the placeholder
        // So that the correct placeholder image will be displayed
        // depending on dark/light mode setting
        guard let url = url, !url.absoluteString.contains("placeholder") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
