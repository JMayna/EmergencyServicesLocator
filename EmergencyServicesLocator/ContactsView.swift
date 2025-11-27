//
//  ContactsView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import SwiftUI

struct ContactsView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Header
                VStack(spacing: 6) {
                    Text("Contacts")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                    
                    Text("Sample test page")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                
                // Sample Contact Card
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("John Doe")
                        .font(.title3.bold())
                        .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
                    
                    Text("Safety Director")
                        .foregroundColor(.gray)
                    
                    Text("Phone: (555) 123-4567")
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
                .padding(.horizontal)
                
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
}

#Preview {
    NavigationStack {
        ContactsView()
    }
}
