//
//  PDFGenerator.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/26/25.
//

import UIKit
import SwiftUI

struct PDFGenerator {
    
    static func generateIncidentPDF(
        reportText: String,
        photos: [UIImage]
    ) -> Data {
        
        let pdfData = NSMutableData()
        
        // PDF page settings
        let pageWidth: CGFloat = 612      // 8.5 inches
        let pageHeight: CGFloat = 792     // 11 inches
        let margin: CGFloat = 40
        
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), nil)
        
        // MARK: - Helper to start a page
        func beginPage() -> CGFloat {
            UIGraphicsBeginPDFPage()
            return margin
        }
        
        var yPosition = beginPage()
        
        // MARK: - Draw Text
        func drawText(_ text: String, font: UIFont, spacingBefore: CGFloat = 12) {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font
            ]
            
            let textRect = CGRect(x: margin, y: yPosition + spacingBefore, width: pageWidth - margin * 2, height: .greatestFiniteMagnitude)
            let attributedText = NSAttributedString(string: text, attributes: attrs)
            
            let textSize = attributedText.boundingRect(
                with: CGSize(width: textRect.width, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                context: nil
            )
            
            // Page break if needed
            if yPosition + spacingBefore + textSize.height > pageHeight - margin {
                yPosition = beginPage()
            }
            
            attributedText.draw(in: CGRect(x: margin, y: yPosition + spacingBefore, width: textRect.width, height: textSize.height))
            
            yPosition += spacingBefore + textSize.height
        }
        
        // Draw title
        drawText("THE ELLIOTT COMPANIES", font: .boldSystemFont(ofSize: 20), spacingBefore: 0)
        drawText("Incident Report", font: .boldSystemFont(ofSize: 18), spacingBefore: 8)
        drawText("Generated: \(formattedDate())", font: .systemFont(ofSize: 12), spacingBefore: 0)
        
        drawText(reportText, font: .systemFont(ofSize: 14), spacingBefore: 20)
        
        // MARK: - Draw Photos
        for (index, img) in photos.enumerated() {
            
            let maxWidth = pageWidth - margin * 2
            let aspect = img.size.height / img.size.width
            let drawHeight = maxWidth * aspect
            
            if yPosition + drawHeight + 20 > pageHeight - margin {
                yPosition = beginPage()
            }
            
            let drawRect = CGRect(x: margin, y: yPosition + 20, width: maxWidth, height: drawHeight)
            img.draw(in: drawRect)
            
            yPosition += drawHeight + 20
            
            // Label for each photo
            drawText("Photo \(index + 1)", font: .italicSystemFont(ofSize: 12), spacingBefore: 4)
        }
        
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
    
    static func formattedDate() -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: Date())
    }
}
