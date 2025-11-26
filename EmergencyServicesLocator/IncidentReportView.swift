import SwiftUI

struct IncidentReportView: View {
    
    // MARK: - Your Information
    @State private var reporterName = ""
    
    // MARK: - Incident Details
    @State private var incidentDate = Date()
    @State private var incidentTime = Date()
    @State private var incidentLocation = ""
    
    // MARK: - Injured Person Information
    @State private var injuredName = ""
    @State private var injuredOccupation = ""
    
    let occupationList = [
        "Carpenter",
        "Carpenter Helper",
        "Electrician",
        "Electrician Helper",
        "HVAC Tech",
        "HVAC Helper",
        "Plumber",
        "Plumber Helper",
        "Truck Driver/Equipment Operator",
        "Supply Warehouse",
        "General Warehouse",
        "Supervisor",
        "Job Superintendent",
        "Office/Admin",
        "Other/Specialist"
    ]
    
    // MARK: - Supervisor Info
    @State private var supervisorName = ""
    @State private var supervisorPhone = ""
    
    // MARK: - Injury Information
    @State private var injuredPersonDescription = ""
    
    @State private var injuryType = ""
    let injuryTypeList = [
        "Minor cuts, abrasions, bruises, sprains or strains (only first aid required on site)",
        "Minor punctures, skin ripped, injury made by small object injury",
        "Minor eye irritation or flying material requiring flushing",
        "Sever cuts or lacerations requiring stitches or treatment",
        "Head face or bone injury requiring medical evaluation",
        "More extreme strain, sprain, possible fracture (affecting movement)",
        "Injury not listed: Note other injury in the \"More Details and Notes\" Section Below",
        "Near Miss Incident (An Incident that could have caused an injury)."
    ]
    
    @State private var treatmentProvided = ""
    let treatmentList = [
        "Minor first aid provided by injured person on site",
        "Minor first aid assistance by an on-site person",
        "Injured Person was taken to ER by another employee",
        "911 was called and ambulance transport was provided",
        "Other response needs to be in the last question or long form",
        "No on site care"
    ]
    
    // MARK: - Possible Causes
    @State private var selectedCauses: Set<String> = []
    let causeList = [
        "Ignoring safety guidelines",
        "Lack of general hazard awareness",
        "Overexertion and fatigue",
        "Improper use of tools and equipment",
        "Inadequate PPE or usage",
        "Risky behavior overexertion",
        "Poor housekeeping",
        "Unsafe lifting or material handling practices",
        "Poor communication between workers",
        "Inadequate training",
        "Possible temporary disorientation",
        "Faulty tools or equipment",
        "Inadequate grounding of machine or tool"
    ]
    
    // MARK: - More Details
    @State private var moreDetails = ""
    
    // MARK: - Photos
    @State private var showImagePicker = false
    @State private var images: [UIImage] = []
    
    // MARK: - Email
    @State private var showMail = false
    
    var body: some View {
        Form {
            
            // MARK: - Your Information
            Section(header: Text("Your Information")) {
                TextField("Name:", text: $reporterName)
            }
            
            // MARK: - Incident Details
            Section(header: Text("Incident Details:")) {
                DatePicker("Date of Accident:", selection: $incidentDate, displayedComponents: .date)
                DatePicker("Time of Accident:", selection: $incidentTime, displayedComponents: .hourAndMinute)
                
                TextField("Accident Location (Include: Floor, Building, Job Name, 911 Address, City and State)", text: $incidentLocation)
            }
            
            // MARK: Injured Information
            Section(header: Text("Injured Individuals Information")) {
                TextField("Injured Person's Name: First and Last", text: $injuredName)
                
                Picker("Injured Person's Occupation", selection: $injuredOccupation) {
                    Text("Select Occupation").tag("")
                    ForEach(occupationList, id: \.self) { job in
                        Text(job).tag(job)
                    }
                }
            }
            
            // MARK: Supervisor
            Section(header: Text("Injured Persons Immediate Supervisors Information")) {
                TextField("Immediate Supervisors Name:", text: $supervisorName)
                TextField("Immediate Supervisors Phone Number", text: $supervisorPhone)
                    .keyboardType(.phonePad)
            }
            
            // MARK: Injury Information
            Section(header: Text("Injury Information")) {
                
                Text("Note Here, in the injured persons own words, their version of what happened (before, during, and immediately after the incident):")
                TextEditor(text: $injuredPersonDescription)
                    .frame(minHeight: 140)
                
                Picker("Pick a statement that best describes the injury:", selection: $injuryType) {
                    Text("Select Injury Type").tag("")
                    ForEach(injuryTypeList, id: \.self) { item in
                        Text(item).tag(item)
                    }
                }
                
                Picker("Describe any first or treatment known to be provided:", selection: $treatmentProvided) {
                    Text("Select Treatment Provided").tag("")
                    ForEach(treatmentList, id: \.self) { item in
                        Text(item).tag(item)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("As a supervisor, select one or two different possible cause of this incident:")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    ForEach(causeList, id: \.self) { cause in
                        MultipleSelectionRow(
                            title: cause,
                            isSelected: selectedCauses.contains(cause)
                        ) {
                            if selectedCauses.contains(cause) {
                                selectedCauses.remove(cause)
                            } else {
                                selectedCauses.insert(cause)
                            }
                        }
                    }
                }
            }
            
            // MARK: More Details
            Section(header: Text("More Details and Notes")) {
                TextEditor(text: $moreDetails)
                    .frame(minHeight: 140)
            }
            
            // MARK: Photos
            Section(header: Text("Optional Photos")) {
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { img in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    if let index = images.firstIndex(of: img) {
                                        images.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(6)
                                }
                            }
                        }
                    }
                }
                
                Button("Add Photo") {
                    showImagePicker = true
                }
            }
            
            // MARK: Submit
            Section {
                Button("Submit Report") {
                    showMail = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Incident Report")
        
        // Photo picker
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                if let img = image { images.append(img) }
            }
        }
        
        // Mail sheet
        .sheet(isPresented: $showMail) {
            MailView(
                subject: "Incident Report Submission",
                body: "Attached are the incident report files.",
                recipients: ["elliottapptestemail@gmail.com"],
                attachments: buildAttachments()
            )
        }
    }
    
    
    // MARK: - Combine PDF + TXT + individual photos
    func buildAttachments() -> [AttachmentData] {
        var attachments: [AttachmentData] = []
        
        // Build raw text for report
        let report = """
        INCIDENT REPORT

        --- YOUR INFORMATION ---
        Name: \(reporterName)

        --- INCIDENT DETAILS ---
        Date of Accident: \(incidentDate)
        Time of Accident: \(incidentTime)
        Accident Location: \(incidentLocation)

        --- INJURED INDIVIDUAL ---
        Name: \(injuredName)
        Occupation: \(injuredOccupation)

        --- SUPERVISOR INFO ---
        Supervisor Name: \(supervisorName)
        Supervisor Phone: \(supervisorPhone)

        --- INJURED PERSON DESCRIPTION ---
        \(injuredPersonDescription)

        --- INJURY TYPE ---
        \(injuryType)

        --- TREATMENT PROVIDED ---
        \(treatmentProvided)

        --- POSSIBLE CAUSES ---
        \(selectedCauses.joined(separator: ", "))

        --- MORE DETAILS ---
        \(moreDetails)
        """
        
        // 1️⃣ TXT FILE
        if let textData = report.data(using: .utf8) {
            attachments.append(
                AttachmentData(
                    data: textData,
                    mimeType: "text/plain",
                    fileName: "IncidentReport.txt"
                )
            )
        }
        
        // 2️⃣ PDF FILE
        let pdfData = PDFGenerator.generateIncidentPDF(
            reportText: report,
            photos: images
        )
        
        attachments.append(
            AttachmentData(
                data: pdfData,
                mimeType: "application/pdf",
                fileName: "IncidentReport.pdf"
            )
        )
        
        // 3️⃣ INDIVIDUAL PHOTOS
        for (index, img) in images.enumerated() {
            if let imgData = img.jpegData(compressionQuality: 0.8) {
                attachments.append(
                    AttachmentData(
                        data: imgData,
                        mimeType: "image/jpeg",
                        fileName: "Photo\(index + 1).jpg"
                    )
                )
            }
        }
        
        return attachments
    }
}



// MARK: - Multi Select Row
struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
