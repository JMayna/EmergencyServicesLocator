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
    
    func startFlow() {
        showImagePicker = true
    }
    
    func imagePicked(_ image: UIImage?) {
        selectedImage = image
        if image != nil {
            showMailView = true
        }
    }
}

// MARK: - Timesheet Email ViewModel
class TimesheetViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showMailView = false
    
    func startFlow() {
        showImagePicker = true
    }
    
    func imagePicked(_ image: UIImage?) {
        selectedImage = image
        if image != nil {
            showMailView = true
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
            ZStack {
                
                // MARK: - Background Gradient
                LinearGradient(
                    colors: [
                        Color(red: 245/255, green: 249/255, blue: 253/255),
                        Color(red: 225/255, green: 235/255, blue: 245/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // MARK: - Header
                    VStack(spacing: 6) {
                        Text("The Elliott Companies")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                        
                        Text("Emergency Services Directory")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Main Button Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        polishedButton(title: "Fire")
                        polishedButton(title: "EMS")
                        polishedButton(title: "Police")
                        polishedButton(title: "Rescue Squad")
                        
                        // Incident Report Navigation
                        NavigationLink {
                            IncidentReportView()
                        } label: {
                            polishedNavButton(title: "Incident Report")
                        }
                        
                        // Email Receipt
                        polishedButton(title: "Email Receipt") {
                            receiptVM.startFlow()
                        }
                        
                        // Email Timesheet
                        polishedButton(title: "Email Timesheet") {
                            timesheetVM.startFlow()
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - SDS Button
                    NavigationLink {
                        SDSCategoryScreen()
                    } label: {
                        Text("SDS Sheets")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 75)
                            .background(Color(red: 10/255, green: 57/255, blue: 102/255))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        
        // MARK: - Receipt Camera
        .sheet(isPresented: $receiptVM.showImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                receiptVM.imagePicked(image)
            }
        }
        
        // MARK: - Receipt Email
        .sheet(isPresented: $receiptVM.showMailView) {
            if let img = receiptVM.selectedImage,
               let data = img.jpegData(compressionQuality: 0.8) {
                
                MailView(
                    subject: "Receipt Submission",
                    body: "Attached is the receipt.",
                    recipients: ["elliottapptestemail@gmail.com"],
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
        
        // MARK: - Timesheet Camera
        .sheet(isPresented: $timesheetVM.showImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                timesheetVM.imagePicked(image)
            }
        }
        
        // MARK: - Timesheet Email
        .sheet(isPresented: $timesheetVM.showMailView) {
            if let img = timesheetVM.selectedImage,
               let data = img.jpegData(compressionQuality: 0.8) {
                
                MailView(
                    subject: "Timesheet Submission",
                    body: "Attached is the timesheet.",
                    recipients: ["elliottapptestemail@gmail.com"], // Change later
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
    }
    
    
    // MARK: - Polished Action Button
    func polishedButton(title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 110)
                .background(Color(red: 10/255, green: 57/255, blue: 102/255))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    // MARK: - Polished Navigation Button (No Button inside)
    func polishedNavButton(title: String) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(Color(red: 10/255, green: 57/255, blue: 102/255))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
}


// MARK: - Button Scale Animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}


#Preview {
    ContentView()
}
