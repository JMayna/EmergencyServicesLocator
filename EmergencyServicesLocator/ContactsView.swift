//
//  ContactsView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import SwiftUI

struct ContactsView: View {
    
    @StateObject private var vm = ContactsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Header
                VStack(spacing: 6) {
                    Text("Contacts")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                    
                    Text("Company Directory")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                
                // Loading
                if vm.isLoading {
                    ProgressView("Loading contacts…")
                        .padding()
                }
                
                // Error message
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                // Contact Cards
                ForEach(vm.contacts) { contact in
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
    
    
    // MARK: - Contact Card Style
    func contactCard(_ contact: Contact) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(contact.fullName)
                .font(.title3.bold())
                .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
            
            Text(contact.title)
                .foregroundColor(.gray)
            
            Text("Company: \(contact.company)")
                .foregroundColor(.gray)
            
            Text("Cell: \(contact.cellPhone)")
                .foregroundColor(.gray)
            
            Text("Work: \(contact.workPhone)")
                .foregroundColor(.gray)
            
            Text("Email: \(contact.email)")
                .foregroundColor(.gray)
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
