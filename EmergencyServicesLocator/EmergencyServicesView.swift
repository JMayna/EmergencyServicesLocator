//
//  EmergencyServicesView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import SwiftUI

struct EmergencyServicesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Emergency Services Locator")
                .font(.title.bold())
                .padding(.top, 20)
            
            Text("This screen will contain:")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("• Ambulance")
                Text("• Rescue Squad")
                Text("• Fire")
                Text("• Police")
            }
            .font(.title3)
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Emergency Services")
    }
}

#Preview {
    EmergencyServicesView()
}
