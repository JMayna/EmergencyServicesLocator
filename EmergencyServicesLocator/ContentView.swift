//
//  ContentView.swift
//  EmergencyServicesLocator
//

import SwiftUI

struct ContentView: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Title
                Text("Elliots")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.top)
                    .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                
                // Grid of main buttons
                LazyVGrid(columns: columns, spacing: 20) {
                    bigButton(title: "Fire")
                    bigButton(title: "EMS")
                    bigButton(title: "Police")
                    bigButton(title: "Rescue Squad")
                }
                
                // SDS Navigation Button
                NavigationLink {
                    SDSCategoryScreen()
                } label: {
                    Text("SDS Sheets")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(Color(red: 10/255, green: 57/255, blue: 102/255))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
    }
    
    // MARK: - Big red grid buttons
    func bigButton(title: String) -> some View {
        Button(action: {}) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(Color(red: 10/255, green: 57/255, blue: 102/255))
                .cornerRadius(20)
        }
    }

}

#Preview {
    ContentView()
}
