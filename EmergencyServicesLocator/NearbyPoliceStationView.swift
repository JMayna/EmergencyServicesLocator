//
//  NearbyPoliceStationView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/27/25.
//

import SwiftUI
import MapKit
import CoreLocation
import Contacts

struct NearbyPoliceStationView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var policeStations: [MKMapItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                Text("Nearest Police Stations")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)
                    .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                
                if isLoading {
                    ProgressView("Searching for nearby police stations…")
                        .padding()
                }
                else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                else if !policeStations.isEmpty {
                    VStack(spacing: 20) {
                        ForEach(policeStations.prefix(3), id: \.self) { station in
                            policeStationCard(station: station)
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
            if policeStations.isEmpty && errorMessage == nil {
                fetchNearestPoliceStations()
            }
        }
    }
    
    
    // MARK: - Police Station Card
    func policeStationCard(station: MKMapItem) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text(station.name ?? "Unknown Police Station")
                .font(.title3.bold())
                .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
            
            if let address = station.placemark.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let formatted = formatter.string(from: address)
                
                Text(formatted)
                    .foregroundColor(.gray)
            }
            
            if let phone = station.phoneNumber {
                Text("Phone: \(phone)")
                    .foregroundColor(.gray)
            }
            
            if let distance = distanceText(to: station) {
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
    
    
    // MARK: - Search for multiple police stations
    func fetchNearestPoliceStations() {
        
        guard let location = locationManager.lastLocation else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "police station"
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
                errorMessage = "No police stations found nearby."
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
            
            // only top 3
            policeStations = Array(sorted.prefix(3))
            
            isLoading = false
        }
    }
}
