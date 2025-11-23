//
//  SDSCategoryScreen.swift
//  EmergencyServicesLocator
//

import SwiftUI

struct SDSCategoryScreen: View {
    
    let categories = [
        "Electrical",
        "Mechanical",
        "Plumbing",
        "General",
        "Glass",
        "Sitework"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("SDS Categories")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                ForEach(categories, id: \.self) { cat in
                    categoryButton(cat)
                }
            }
            .padding()
        }
        .navigationTitle("SDS Sheet")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func categoryButton(_ title: String) -> some View {
        Button(action: {
            // open category
        }) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
}

#Preview {
    SDSCategoryScreen()
}
