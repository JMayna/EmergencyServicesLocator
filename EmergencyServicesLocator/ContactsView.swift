//
//  ContactsView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import SwiftUI

struct ContactsView: View {
    
    @StateObject private var vm = ContactsViewModel()
    @State private var searchText = ""
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty { return vm.contacts }
        
        return vm.contacts.filter { contact in
            contact.fullName.localizedCaseInsensitiveContains(searchText) ||
            contact.title.localizedCaseInsensitiveContains(searchText) ||
            contact.company.localizedCaseInsensitiveContains(searchText) ||
            contact.cellPhone.localizedCaseInsensitiveContains(searchText) ||
            contact.workPhone.localizedCaseInsensitiveContains(searchText) ||
            contact.email.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // --------------------------------------------------------
                // HEADER
                // --------------------------------------------------------
                VStack(spacing: 6) {
                    Text("Contacts")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                    
                    Text("Company Directory")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                
                // --------------------------------------------------------
                // SEARCH BAR
                // --------------------------------------------------------
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search contacts…", text: $searchText)
                        .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                
                
                // --------------------------------------------------------
                // LOADING
                // --------------------------------------------------------
                if vm.isLoading {
                    ProgressView("Loading contacts…")
                        .padding()
                }
                
                
                // --------------------------------------------------------
                // ERROR
                // --------------------------------------------------------
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                // --------------------------------------------------------
                // CONTACT LIST
                // --------------------------------------------------------
                ForEach(filteredContacts) { contact in
                    contactCard(contact)
                        .padding(.horizontal)
                }
                
                Spacer().frame(height: 40)
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 245/255, green: 247/255, blue: 251/255),
                    Color(red: 230/255, green: 235/255, blue: 244/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // --------------------------------------------------------
    // CONTACT CARD
    // --------------------------------------------------------
    
    func contactCard(_ contact: Contact) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(contact.fullName)
                .font(.title3.bold())
                .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
            
            Text(contact.title)
                .foregroundColor(.gray)
            
            Text("Company: \(contact.company)")
                .foregroundColor(.gray)
            
            
            // -------------------------------
            // TAP-TO-CALL: CELL PHONE
            // -------------------------------
            if let cellURL = URL(string: "tel://\(contact.cellPhone.onlyDigits)") {
                Link("Cell: \(contact.cellPhone)", destination: cellURL)
                    .foregroundColor(Color.blue.opacity(0.8))
                    .underline()
            }
            
            // -------------------------------
            // TAP-TO-CALL: WORK PHONE
            // -------------------------------
            if let workURL = URL(string: "tel://\(contact.workPhone.onlyDigits)") {
                Link("Work: \(contact.workPhone)", destination: workURL)
                    .foregroundColor(Color.blue.opacity(0.8))
                    .underline()
            }
            
            
            // -------------------------------
            // TAP-TO-EMAIL
            // -------------------------------
            if let emailURL = URL(string: "mailto:\(contact.email)") {
                Link("Email: \(contact.email)", destination: emailURL)
                    .foregroundColor(Color.blue.opacity(0.8))
                    .underline()
            }
            
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                .overlay(
                    Rectangle()
                        .fill(Color(red: 10/255, green: 57/255, blue: 102/255))
                        .frame(width: 6),
                    alignment: .leading
                )
        )
    }
}

#Preview {
    NavigationStack {
        ContactsView()
    }
}


// ------------------------------------------------------------
// DIGITS-ONLY EXTENSION (for tap-to-call)
// ------------------------------------------------------------
extension String {
    var onlyDigits: String {
        self.filter { $0.isNumber }
    }
}
