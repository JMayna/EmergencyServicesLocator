//
//  SDSModel.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/24/25.
//

import Foundation

struct SDSIndex: Codable {
    let categories: [String: [String: String]]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        categories = try container.decode([String: [String: String]].self)
    }
}
