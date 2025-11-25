import SwiftUI
import PDFKit

struct PDFViewer: View {
    let urlString: String
    @State private var document: PDFDocument? = nil
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading PDF...")
            } else if let document = document {
                PDFKitView(document: document)
            } else {
                Text("Failed to load PDF")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            loadPDF()
        }
        .navigationTitle("SDS Sheet")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadPDF() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let pdf = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.document = pdf
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = document
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
