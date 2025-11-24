//
//  SDSDataLoader.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/24/25.
//

import Foundation

class SDSDataLoader: ObservableObject {
    @Published var categories: [String: [String: String]] = [:]
    
    private let indexURL = "https://raw.githubusercontent.com/JMayna/sds-documents/main/index.json"
    private let baseURL = "https://raw.githubusercontent.com/JMayna/sds-documents/main/"
    
    init() {
        loadIndex()
    }
    
    func loadIndex() {
        guard let url = URL(string: indexURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let decoded = try? JSONDecoder().decode(SDSIndex.self, from: data)
            else {
                print("Failed decoding index.json")
                return
            }
            
            DispatchQueue.main.async {
                self.categories = decoded.categories
            }
        }.resume()
    }
    
    func fullURL(for file: String) -> String {
        return baseURL + file
    }
}
