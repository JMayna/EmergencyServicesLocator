import SwiftUI

struct SDSCategoryScreen: View {
    @StateObject private var loader = SDSDataLoader()
    
    var body: some View {
        VStack {
            if loader.categories.isEmpty {
                ProgressView("Loading SDS...")
            } else {
                List {
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
        .navigationTitle("SDS Categories")
    }
}
