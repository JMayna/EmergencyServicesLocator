import SwiftUI

struct SDSSheetListScreen: View {
    let category: String
    let sheets: [String : String]
    let loader: SDSDataLoader

    @State private var searchText = ""

    var filteredSheets: [String] {
        if searchText.isEmpty {
            return sheets.keys.sorted()
        } else {
            return sheets.keys
                .filter { $0.localizedCaseInsensitiveContains(searchText) }
                .sorted()
        }
    }

    var body: some View {
        List {
            ForEach(filteredSheets, id: \.self) { name in
                NavigationLink(name) {
                    PDFViewer(urlString: loader.fullURL(for: sheets[name]!))
                }
            }
        }
        .navigationTitle(category)
        .searchable(text: $searchText, prompt: "Search SDS...")
    }
}
