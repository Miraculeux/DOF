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
                resultValue(result.front)
            }
            
            HStack {
                Text("Behind subject:")
                Spacer()
                resultValue(result.back)
            }
            
            HStack {
                Text("Near Limit:")
                Spacer()
                resultValue(result.nearLimit)
            }

            HStack {
                Text("Far Limit:")
                Spacer()
                resultValue(result.farLimit)
            }

            HStack {
                Text("Total DOF:")
                Spacer()
                resultValue(result.totalDOF)
            }

            HStack {
                Text("Hyperfocal:")
                Spacer()
                resultValue(result.hyperfocalDistance)
            }
        } // ────── VStack close ──────
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }

    /// Formats a double as “xx.xx m” with two decimal places
    @ViewBuilder
    private func resultValue(_ value: Double) -> some View {
        Text(String(format: "%.2f m", value))
            .fontWeight(.semibold)
    }
}
