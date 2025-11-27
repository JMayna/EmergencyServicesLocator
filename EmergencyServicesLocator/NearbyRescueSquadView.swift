//
//  NearbyRescueSquadView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/27/25.
//

import SwiftUI
import MapKit
import CoreLocation
import Contacts

struct NearbyRescueSquadView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var rescueSquads: [MKMapItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                Text("Nearest Rescue Squads")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)
                    .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                
                if isLoading {
                    ProgressView("Searching for nearby rescue squads…")
                        .padding()
                }
                else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                else if !rescueSquads.isEmpty {
                    VStack(spacing: 20) {
                        ForEach(rescueSquads.prefix(3), id: \.self) { squad in
                            rescueSquadCard(squad: squad)
                                .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
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
        .onReceive(locationManager.$lastLocation) { location in
            guard location != nil else { return }
            if rescueSquads.isEmpty && errorMessage == nil {
                fetchRescueSquads()
            }
        }
    }
    
    
    // MARK: - Rescue Squad Card
    func rescueSquadCard(squad: MKMapItem) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text(squad.name ?? "Unknown Rescue Squad")
                .font(.title3.bold())
                .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
            
            if let address = squad.placemark.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let formatted = formatter.string(from: address)
                
                Text(formatted)
                    .foregroundColor(.gray)
            }
            
            if let phone = squad.phoneNumber {
                Text("Phone: \(phone)")
                    .foregroundColor(.gray)
            }
            
            if let distance = distanceText(to: squad) {
                Text("Distance: \(distance)")
                    .foregroundColor(.gray)
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
    
    
    // MARK: - Distance
    func distanceText(to item: MKMapItem) -> String? {
        guard let userLoc = locationManager.lastLocation else { return nil }
        
        let itemLoc = CLLocation(latitude: item.placemark.coordinate.latitude,
                                 longitude: item.placemark.coordinate.longitude)
        
        let distanceMeters = userLoc.distance(from: itemLoc)
        let distanceMiles = distanceMeters / 1609.34
        
        return String(format: "%.1f miles", distanceMiles)
    }
    
    
    // MARK: - Search for rescue squads
    func fetchRescueSquads() {
        
        guard let location = locationManager.lastLocation else { return }
        
        let request = MKLocalSearch.Request()
        
        // Use multiple common phrases to catch all services:
        request.naturalLanguageQuery = "rescue squad"
        
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            if let error = error {
                errorMessage = "Search error: \(error.localizedDescription)"
                isLoading = false
                return
            }
            
            guard let items = response?.mapItems, !items.isEmpty else {
                errorMessage = "No rescue squads found nearby."
                isLoading = false
                return
            }
            
            // Sort by distance
            let sorted = items.sorted { a, b in
                let locA = CLLocation(latitude: a.placemark.coordinate.latitude,
                                      longitude: a.placemark.coordinate.longitude)
                let locB = CLLocation(latitude: b.placemark.coordinate.latitude,
                                      longitude: b.placemark.coordinate.longitude)
                
                let userLoc = locationManager.lastLocation!
                
                return userLoc.distance(from: locA) < userLoc.distance(from: locB)
            }
            
            rescueSquads = Array(sorted.prefix(3))
            isLoading = false
        }
    }
}
