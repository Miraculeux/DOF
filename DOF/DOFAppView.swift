import SwiftUI

/// The single screen that ties everything together
struct DOFAppView: View {
    // MARK: - State
    
    @State private var aperture: Double = 2.8
    @State private var focalLength: Double = 50.0
    @State private var sensorCropFactor: CropFactor = .fullFrame
    @State private var circleOfConfusion: Double = 0.03
    @State private var subjectDistance: Double = 0.5
    
    @State private var result: DOFCalculator.Result? = nil
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    DOFInputView(
                        aperture: $aperture,
                        focalLength: $focalLength,
                        sensorCropFactor: $sensorCropFactor,
                        circleOfConfusion: $circleOfConfusion,
                        subjectDistance: $subjectDistance
                    )
                    
                    Button("Calculate DOF") {
                        let params = DOFCalculator.Parameters(
                            aperture: aperture,
                            focalLength: focalLength,
                            sensorCropFactor: sensorCropFactor.rawValue,
                            circleOfConfusion: circleOfConfusion,
                            subjectDistance: subjectDistance
                        )
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                        result = DOFCalculator.calculate(params)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    
                    
                    if let result = result {
                        DOFResultView(result: result)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("DOF Calculator")
        }
    }
}
