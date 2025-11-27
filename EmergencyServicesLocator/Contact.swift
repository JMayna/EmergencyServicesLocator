//
//  Contact.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import Foundation

struct Contact: Identifiable, Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let company: String
    let title: String
    let cellPhone: String
    let workPhone: String
    let email: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
