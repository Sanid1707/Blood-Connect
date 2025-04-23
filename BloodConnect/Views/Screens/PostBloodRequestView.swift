import SwiftUI

struct PostBloodRequestView: View {
    @State private var patientName = ""
    @State private var selectedBloodType: String = "B+"
    @State private var bloodUnit: Double = 2
    @State private var mobileNumber = ""
    @State private var selectedLocation = ""
    @State private var gender = ""
    @State private var birthDate = Date()

    let bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    let genders = ["Male", "Female", "Other"]
    let locations = ["Cork", "Dundalk", "Dublin", "Maynooth"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                    Spacer()
                    Text("Post A Request")
                        .font(.headline)
                    Spacer()
                    Spacer().frame(width: 24) // spacer to balance the back arrow
                }

                // Patient Name
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Patient Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("Patient Name", text: $patientName)
                        .padding(.horizontal,40)
                        .padding(.vertical,15)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Image(systemName: "person")
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .foregroundColor(.gray)
                        )
                }

                // Blood Group
                Text("Select Blood Group")
                    .fontWeight(.semibold)
                    .font(.subheadline)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 12) {
                    ForEach(bloodGroups, id: \.self) { group in
                        Button(action: {
                            selectedBloodType = group
                        }) {
                            Text(group)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedBloodType == group ? AppColor.primaryRed.opacity(0.2) : Color(UIColor.systemGray5))
                                .foregroundColor(.black)
                                .cornerRadius(50)
                                .overlay(
                                    Circle()
                                        .stroke(selectedBloodType == group ? AppColor.primaryRed: Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }

                // Blood Unit
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Blood Unit")
                        .fontWeight(.semibold)
                    Slider(value: $bloodUnit, in: 1...10, step: 1)
                        .accentColor(Color(red: 230/255, green: 4/255, blue: 73/255))
                    Text("\(Int(bloodUnit)) Unit")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // Mobile Number
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Mobile Number")
                        .fontWeight(.semibold)
                        .padding(.vertical,15)
                    TextField("Mobile Number", text: $mobileNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }

                // Location Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select A Location")
                        .fontWeight(.semibold)
                        
                    Picker("Select A Location", selection: $selectedLocation) {
                        Text("Select A Location").tag("")
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }

                // Gender and Date
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Gender")
                            .fontWeight(.semibold)
                        Picker("Gender", selection: $gender) {
                            Text("Gender").tag("")
                            ForEach(genders, id: \.self) { g in
                                Text(g).tag(g)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }

                    VStack(alignment: .leading) {
                        Text("Date")
                            .fontWeight(.semibold)
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                    }
                }

                // Send Request Button
                Button(action: {
                    // send request logic
                }) {
                    Text("Send Request")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColor.primaryRed)
                        .cornerRadius(12)
                }

            }
            .padding()
        }
    }
}


#Preview {
    PostBloodRequestView()
}
