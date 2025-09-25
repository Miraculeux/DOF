import SwiftUI

/// Displays the DOF calculation results
struct DOFResultView: View {
    let result: DOFCalculator.Result

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DOF Results")
                .font(.headline)

            // ────── Result rows ──────
            HStack {
                Text("In front of subject:")
                Spacer()
                resultValue(result.front * 100, unit: "cm")
            }
            
            HStack {
                Text("Behind subject:")
                Spacer()
                resultValue(result.back * 100,  unit: "cm")
            }
            
            HStack {
                Text("Near Limit:")
                Spacer()
                resultValue(result.nearLimit,  unit: "m")
            }

            HStack {
                Text("Far Limit:")
                Spacer()
                resultValue(result.farLimit,  unit: "m")
            }

            HStack {
                Text("Total DOF:")
                Spacer()
                resultValue(result.totalDOF * 100,  unit: "cm")
            }

            HStack {
                Text("Hyperfocal:")
                Spacer()
                resultValue(result.hyperfocalDistance,  unit: "m")
            }
        } // ────── VStack close ──────
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }

    /// Formats a double as “xx.xx m” with two decimal places
    @ViewBuilder
    private func resultValue(_ value: Double, unit: String) -> some View {
        Text(String(format: "%.2f \(unit)", value))
            .fontWeight(.semibold)
    }
}
