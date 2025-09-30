import Foundation

/// Represents the three supported sensor types.
enum CropFactor: String, CaseIterable {
    case fullFrame = "Full Frame"
    case canonAPSC = "Canon APS‑C"
    case sonyAPSC = "Sony APS‑C"
}
