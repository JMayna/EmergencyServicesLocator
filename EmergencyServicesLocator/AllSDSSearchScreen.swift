//
//  AllSDSSearchScreen.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/25/25.
//
import SwiftUI

struct AllSDSSearchScreen: View {
    @ObservedObject var loader: SDSDataLoader
    
    @State private var searchText = ""
    
    var allSheets: [(category: String, name: String, file: String)] {
        loader.categories.flatMap { category, sheets in
            sheets.map { (category, $0.key, $0.value) }
        }
    }
    
    var filteredSheets: [(category: String, name: String, file: String)] {
        if searchText.isEmpty {
            return allSheets
        } else {
            return allSheets.filter { sheet in
                sheet.name.localizedCaseInsensitiveContains(searchText)
                || sheet.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredSheets, id: \.name) { sheet in
                NavigationLink {
                    PDFViewer(
                        urlString: loader.fullURL(for: sheet.file)
                    )
                } label: {
                    VStack(alignment: .leading) {
                        Text(sheet.name)
                            .font(.headline)
                        Text(sheet.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Search SDS")
        .searchable(text: $searchText, prompt: "Search all SDS…")
    }
}
