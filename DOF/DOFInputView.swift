import SwiftUI

/// View that lets the user enter camera parameters
struct DOFInputView: View {
    @Binding var aperture: Double
    @Binding var focalLength: Double
    @Binding var sensorCropFactor: CropFactor
    @Binding var circleOfConfusion: Double
    @Binding var subjectDistance: Double
    
    @FocusState private var isSubjectDistanceFocused: Bool
    
    private var numberFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        return f
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Camera Settings")
                .font(.headline)
            
            HStack { Text("Sensor Crop Factor:") }
            Picker(selection: $sensorCropFactor, label: Text(sensorCropFactor.title)) {
                ForEach(CropFactor.allCases) { cf in
                    Text(cf.title).tag(cf)
                }
            }
            .pickerStyle(.segmented)   // you can use .menu or .wheel if preferred
            
            HStack { Text("Aperture (f‑no):") }
            Slider(value: $aperture, in: 1.4...22, step: 0.1)
            Text(String(format: "%.1f", aperture))
            
            HStack { Text("Focal Length (mm):") }
            Slider(value: $focalLength, in: 16...200, step: 1)
            Text(String(format: "%.0f mm", focalLength))
            
            HStack {
                Text("Subject Distance (m)")
                Spacer()
                TextField("", value: $subjectDistance, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .focused($isSubjectDistanceFocused)
                    .onAppear {
                        // Ensure keyboard appears when view appears
                        DispatchQueue.main.async {
                            self.isSubjectDistanceFocused = true
                        }
                    }
            }
            
            LabeledTextField(label: "Circle of Confusion (mm)", value: $circleOfConfusion)
        }
        .padding()
    }
}

/// Small helper for a label + numeric text field
private struct LabeledTextField: View {
    let label: String
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
