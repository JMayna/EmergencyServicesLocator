import SwiftUI

struct SDSCategoryScreen: View {
    @StateObject private var loader = SDSDataLoader()
    @State private var searchText = ""
    
    // Flatten all sheets into a searchable list
    var allSheets: [(category: String, name: String, file: String)] {
        loader.categories.flatMap { category, sheets in
            sheets.map { (category, $0.key, $0.value) }
        }
    }
    
    // Filter across ALL categories
    var filteredSheets: [(category: String, name: String, file: String)] {
        if searchText.isEmpty {
            return []
        }
        return allSheets.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
            || item.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            if loader.categories.isEmpty {
                ProgressView("Loading SDS...")
            } else {
                List {
                    
                    // 🔎 SEARCH RESULTS (only appear when searching)
                    if !searchText.isEmpty {
                        Section(header: Text("Search Results")) {
                            ForEach(filteredSheets, id: \.name) { item in
                                NavigationLink(destination:
                                    PDFViewer(urlString: loader.fullURL(for: item.file))
                                ) {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                        Text(item.category)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    
                    // 📂 CATEGORY LIST (only appears when NOT searching)
                    if searchText.isEmpty {
                        Section(header: Text("Categories")) {
                            ForEach(loader.categories.keys.sorted(), id: \.self) { category in
                                NavigationLink(category) {
                                    SDSSheetListScreen(
                                        category: category,
                                        sheets: loader.categories[category]!,
                                        loader: loader
                                    )
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search all SDS…")
            }
        }
        .navigationTitle("SDS Categories")
    }
}
