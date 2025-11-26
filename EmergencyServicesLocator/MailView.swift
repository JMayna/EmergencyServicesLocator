//
//  MailView.swift
//  EmergencyServicesLocator
//
//  Created by Jordan Maynard on 11/25/25.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    let subject: String
    let body: String
    let recipients: [String]
    let attachment: Data?
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        vc.setToRecipients(recipients)
        vc.mailComposeDelegate = context.coordinator
        
        if let attachment {
            vc.addAttachmentData(attachment, mimeType: "image/jpeg", fileName: "receipt.jpg")
        }
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            parent.dismiss()
        }
    }
}
