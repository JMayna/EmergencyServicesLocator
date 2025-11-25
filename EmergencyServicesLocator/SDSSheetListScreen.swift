import SwiftUI

struct SDSSheetListScreen: View {
    let category: String
    let sheets: [String : String]
    let loader: SDSDataLoader
    
    var body: some View {
        List {
            ForEach(sheets.keys.sorted(), id: \.self) { name in
                NavigationLink(name) {
                    PDFViewer(urlString: loader.fullURL(for: sheets[name]!))
                }
            }
        }
        .navigationTitle(category)
    }
}
