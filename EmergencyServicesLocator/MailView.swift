import SwiftUI
import MessageUI

struct AttachmentData {
    let data: Data
    let mimeType: String
    let fileName: String
}

struct MailView: UIViewControllerRepresentable {
    
    var subject: String
    var body: String
    var recipients: [String]
    var attachments: [AttachmentData] = []
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        
        vc.setSubject(subject)
        vc.setToRecipients(recipients)
        vc.setMessageBody(body, isHTML: false)
        
        
        for item in attachments {
            vc.addAttachmentData(item.data,
                                 mimeType: item.mimeType,
                                 fileName: item.fileName)
        }
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
