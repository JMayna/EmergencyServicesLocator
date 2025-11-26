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
                        Color(red: 240/255, green: 243/255, blue: 247/255),
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
                            .font(.largeTitle.bold())
                            .foregroundColor(Color(red: 10/255, green: 57/255, blue: 102/255))
                        
                        Text("Multi-Trades Commerical Contracting")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Modern Card Button Grid
                    LazyVGrid(columns: columns, spacing: 22) {
                        
                        modernCardButton(title: "Fire")
                        modernCardButton(title: "EMS")
                        modernCardButton(title: "Police")
                        modernCardButton(title: "Rescue Squad")
                        
                        // Incident Report Navigation
                        NavigationLink {
                            IncidentReportView()
                        } label: {
                            modernCardNavButton(title: "Incident Report")
                        }
                        
                        // Email Receipt
                        modernCardButton(title: "Email Receipt") {
                            receiptVM.startFlow()
                        }
                        
                        // Email Timesheet
                        modernCardButton(title: "Email Timesheet") {
                            timesheetVM.startFlow()
                        }

                        // ⭐ SDS inside the grid — same size as all cards
                        NavigationLink {
                            SDSCategoryScreen()
                        } label: {
                            modernCardNavButton(title: "SDS Sheets")
                        }
                    }
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
                    recipients: ["elliottapptestemail@gmail.com"],
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
    
    
    // MARK: - ⭐ Modern Action Button
    func modernCardButton(title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity, minHeight: 130)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(red: 10/255, green: 57/255, blue: 102/255))
                        .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 6)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    // MARK: - ⭐ Modern Navigation Card
    func modernCardNavButton(title: String) -> some View {
        Text(title)
            .font(.title3.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity, minHeight: 130)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(red: 10/255, green: 57/255, blue: 102/255))
                    .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 6)
            )
    }
}


// MARK: - Button Tap Animation
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
