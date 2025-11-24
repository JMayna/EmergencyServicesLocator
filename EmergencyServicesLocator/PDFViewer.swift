import SwiftUI
import PDFKit

struct PDFViewer: View {
    let urlString: String
    
    var body: some View {
        PDFKitView(urlString: urlString)
            .navigationTitle("SDS Sheet")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFKitView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
            pdfView.document = PDFDocument(data: data)
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
