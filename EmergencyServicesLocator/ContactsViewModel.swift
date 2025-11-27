//
//  ContactsViewModel.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import Foundation

class ContactsViewModel: ObservableObject {
    
    @Published var contacts: [Contact] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    private let urlString =
        "https://raw.githubusercontent.com/Jmayna/elliott-contacts/main/contacts.json"
    
    init() {
        fetchContacts()
    }
    
    func fetchContacts() {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received."
                    self.isLoading = false
                    return
                }
                
                do {
                    self.contacts = try JSONDecoder().decode([Contact].self, from: data)
                    self.isLoading = false
                } catch {
                    self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
            
        }.resume()
    }
}
