//
//  ContentView.swift
//  EmergencyServicesLocator
//

import SwiftUI
import MessageUI

// MARK: - Email Receipt ViewModel
class EmailViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showMailView = false
    @Published var showMailUnavailableAlert = false
    @Published var mailErrorMessage: String?
    
    func startFlow() {
        selectedImage = nil
        showImagePicker = true
    }
    
    func imagePicked(_ image: UIImage?) {
        selectedImage = image
    }
    
    func presentMailIfAvailable() {
        guard selectedImage != nil else { return }
        
        if MFMailComposeViewController.canSendMail() {
            showMailView = true
        } else {
            mailErrorMessage = "Mail is not configured on this device."
            showMailUnavailableAlert = true
        }
    }
}

// MARK: - Timesheet Email ViewModel
class TimesheetViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showMailView = false
    @Published var showMailUnavailableAlert = false
    @Published var mailErrorMessage: String?
    
    func startFlow() {
        selectedImage = nil
        showImagePicker = true
    }
    
    func imagePicked(_ image: UIImage?) {
        selectedImage = image
    }
    
    func presentMailIfAvailable() {
        guard selectedImage != nil else { return }
        
        if MFMailComposeViewController.canSendMail() {
            showMailView = true
        } else {
            mailErrorMessage = "Mail is not configured on this device."
            showMailUnavailableAlert = true
        }
    }
}

struct ContentView: View {
    
    @StateObject var receiptVM = EmailViewModel()
    @StateObject var timesheetVM = TimesheetViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    
                    // MARK: - Header
                    VStack(spacing: 6) {
                        Text("The Elliott Companies")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                        
                        Text("Employee Tools")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    
                    
                    // ========================================================
                    // MARK: - OPERATIONS  (Contacts added here)
                    // ========================================================
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Operations")
                            .font(.title2.bold())
                            .padding(.leading)
                            .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            // Incident Report
                            NavigationLink {
                                IncidentReportView()
                            } label: {
                                enterpriseCardNavButton(title: "Incident Report")
                            }
                            
                            // CONTACTS — NEW BUTTON
                            NavigationLink {
                                ContactsView()   // <-- Sample page for now
                            } label: {
                                enterpriseCardNavButton(title: "Contacts")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    // ========================================================
                    // MARK: - ACCOUNTING
                    // ========================================================
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Accounting")
                            .font(.title2.bold())
                            .padding(.leading)
                            .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            enterpriseCardButton(title: "Email Receipt") {
                                receiptVM.startFlow()
                            }
                            
                            enterpriseCardButton(title: "Email Timesheet") {
                                timesheetVM.startFlow()
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    // ========================================================
                    // MARK: - SAFETY DOCUMENTS
                    // ========================================================
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Safety Documents")
                            .font(.title2.bold())
                            .padding(.leading)
                            .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            NavigationLink {
                                SDSCategoryScreen()
                            } label: {
                                enterpriseCardNavButton(title: "SDS Documents")
                            }
                            
                            NavigationLink {
                                EmergencyServicesView()
                            } label: {
                                enterpriseCardNavButton(title: "Emergency Services Locator")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 245/255, green: 247/255, blue: 251/255),
                        Color(red: 230/255, green: 235/255, blue: 244/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
        
        
        // MARK: - Receipt Camera
        .sheet(isPresented: $receiptVM.showImagePicker, onDismiss: {
            receiptVM.presentMailIfAvailable()
        }) {
            ImagePicker(sourceType: .camera) { img in
                receiptVM.imagePicked(img)
            }
        }
        
        // MARK: - Receipt Email
        .sheet(isPresented: $receiptVM.showMailView) {
            if let img = receiptVM.selectedImage,
               let data = img.jpegData(compressionQuality: 0.8) {
                
                MailView(
                    subject: "Receipt Submission",
                    body: "Attached is the receipt.",
                    recipients: ["JeffT@ellcoky.com"],
                    attachments: [
                        AttachmentData(
                            data: data,
                            mimeType: "image/jpeg",
                            fileName: "Receipt.jpg"
                        )
                    ]
                )
            }
        }
        .alert("Cannot Send Mail", isPresented: $receiptVM.showMailUnavailableAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(receiptVM.mailErrorMessage ?? "Mail is not available on this device.")
        }
        
        
        // MARK: - Timesheet Camera
        .sheet(isPresented: $timesheetVM.showImagePicker, onDismiss: {
            timesheetVM.presentMailIfAvailable()
        }) {
            ImagePicker(sourceType: .camera) { img in
                timesheetVM.imagePicked(img)
            }
        }
        
        // MARK: - Timesheet Email
        .sheet(isPresented: $timesheetVM.showMailView) {
            if let img = timesheetVM.selectedImage,
               let data = img.jpegData(compressionQuality: 0.8) {
                
                MailView(
                    subject: "Timesheet Submission",
                    body: "Attached is the timesheet.",
                    recipients: ["JeffT@ellcoky.com"],
                    attachments: [
                        AttachmentData(
                            data: data,
                            mimeType: "image/jpeg",
                            fileName: "Timesheet.jpg"
                        )
                    ]
                )
            }
        }
        .alert("Cannot Send Mail", isPresented: $timesheetVM.showMailUnavailableAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(timesheetVM.mailErrorMessage ?? "Mail is not available on this device.")
        }
    }
    
    
    // MARK: - Card Buttons (Shared)
    
    func enterpriseCardButton(title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            enterpriseCardStyle(title: title)
        }
    }
    
    func enterpriseCardNavButton(title: String) -> some View {
        enterpriseCardStyle(title: title)
    }
    
    func enterpriseCardStyle(title: String) -> some View {
        HStack {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(Color(red: 25/255, green: 40/255, blue: 70/255))
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                .overlay(
                    Rectangle()
                        .fill(Color(red: 10/255, green: 57/255, blue: 102/255))
                        .frame(width: 6),
                    alignment: .leading
                )
        )
    }
}

#Preview {
    ContentView()
}
