//
//  ContentView.swift
//  EmergencyServicesLocator
//

import SwiftUI
import MessageUI

class EmailViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showMailView = false
    
    func startEmailFlow() {
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
    
    @StateObject var emailVM = EmailViewModel()
    
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
                    
                    // MARK: - Button Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        polishedButton(title: "Fire")
                        polishedButton(title: "EMS")
                        polishedButton(title: "Police")
                        polishedButton(title: "Rescue Squad")
                        
                        // INCIDENT REPORT BUTTON (NavigationLink)
                        NavigationLink {
                            IncidentReportView()
                        } label: {
                            polishedNavButton(title: "Incident Report")
                        }
                        
                        // EMAIL RECEIPT BUTTON
                        polishedButton(title: "Email Receipt") {
                            emailVM.startEmailFlow()
                        }
                        
                        polishedButton(title: "Email Timesheet")
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
        
        // MARK: - Image Picker Sheet
        .sheet(isPresented: $emailVM.showImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                emailVM.imagePicked(image)
            }
        }
        
        // MARK: - Mail Composer Sheet
        .sheet(isPresented: $emailVM.showMailView) {
            if let data = emailVM.selectedImage?.jpegData(compressionQuality: 0.8) {
                
                let attachments = [
                    AttachmentData(
                        data: data,
                        mimeType: "image/jpeg",
                        fileName: "Receipt.jpg"
                    )
                ]
                
                MailView(
                    subject: "Receipt Submission",
                    body: "Attached is the receipt.",
                    recipients: ["elliottapptestemail@gmail.com"],
                    attachments: attachments
                )
            }
        }

    }
    
    // MARK: - Polished Reusable Button (Action-based)
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
    
    // MARK: - Polished Navigation Button (For NavigationLink)
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


// MARK: - Press Animation (Scale Effect)
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
