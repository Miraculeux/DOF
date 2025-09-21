/// Represents the three supported sensor types.
enum CropFactor: Double, CaseIterable, Identifiable {
    case fullFrame = 1.0
    case canonAPSC = 1.6
    case sonyAPSC   = 1.5

    var id: Double { rawValue }

    /// Text that will appear in the picker.
    var title: String {
        switch self {
        case .fullFrame: return "Full Frame"
        case .canonAPSC: return "Canon APS‑C"
        case .sonyAPSC:  return "Sony APS‑C"
        }
    }

    /// Convenience – convert from a raw Double back to the enum.
    static func from(_ value: Double) -> CropFactor {
        // The values are unique, so we can just use `first`.
        return self.allCases.first { abs($0.rawValue - value) < 0.0001 } ?? .fullFrame
    }
}
