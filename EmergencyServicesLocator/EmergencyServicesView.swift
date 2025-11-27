import SwiftUI

struct EmergencyServicesView: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                
                // Header
                VStack(spacing: 6) {
                    Text("Emergency Services")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                    
                    Text("Locator")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                
                // ========================================================
                // BUTTON GRID — Matching ContentView.swift
                // ========================================================
                LazyVGrid(columns: columns, spacing: 22) {
                    
                    // Ambulance (placeholder)
                    NavigationLink {
                        NearbyAmbulanceView()
                    } label: {
                        enterpriseCardNavButton(title: "Ambulance")
                    }

                    
                    // Rescue Squad (placeholder)
                    NavigationLink {
                        NearbyRescueSquadView()
                    } label: {
                        enterpriseCardNavButton(title: "Rescue Squad")
                    }

                    
                    // FIRE
                    NavigationLink {
                        NearbyFireStationView()
                    } label: {
                        enterpriseCardNavButton(title: "Fire")
                    }
                    //Police
                    NavigationLink {
                        NearbyPoliceStationView()
                    } label: {
                        enterpriseCardNavButton(title: "Police")
                    }

                }
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 40)
            }
        }
        
        // Background (same style as ContentView)
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
        
        .navigationTitle("Emergency Services")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // ========================================================
    // MARK: - Enterprise Card Style (Same Card Look as Home)
    // ========================================================
    
    func enterpriseCardNavButton(title: String) -> some View {
        HStack {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity, minHeight: 120)
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
        EmergencyServicesView()
    }
}
