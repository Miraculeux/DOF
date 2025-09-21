import Foundation

/// All DOF‑related math lives here.
final class DOFCalculator {
    
    /// Parameters that the user enters
    struct Parameters {
        let aperture: Double          // f‑stop (e.g. 2.8, 5.6)
        let focalLength: Double       // mm (e.g. 50)
        let sensorCropFactor: Double  // e.g. 1.0 (full‑frame), 1.5 (APS‑C)
        let circleOfConfusion: Double // mm (e.g. 0.03 for full‑frame)
        let subjectDistance: Double
    }
    
    /// Result of a DOF calculation
    struct Result {
        let nearLimit: Double
        let farLimit: Double
        let totalDOF: Double
        let hyperfocalDistance: Double
        let front: Double
        let back: Double
    }
    
    /// Public API – returns a `Result` for the supplied parameters
    static func calculate(_ params: Parameters) -> Result {
        // 1. Effective focal length (adjust for crop factor)
        let f = params.focalLength / params.sensorCropFactor
        
        // 2. Hyperfocal distance (meters)
        let H = (f * f) / (params.aperture * params.circleOfConfusion)
        
        // 3. Near and far limits
        let distanceMM = params.subjectDistance * 1000
        let near  = (distanceMM * (H - params.focalLength)) / (H + distanceMM - params.focalLength)
        let far   = (distanceMM * (H + params.focalLength)) / (H - distanceMM + params.focalLength)
        
        // Convert back to meters
        let nearM = near / 1000.0
        let farM = far / 1000.0
        // 4. Total DOF
        let totalDOF = farM - nearM
        
        let front = max(0, distanceMM - near) / 1000
        let back = max(0, far - distanceMM) / 1000
        
        return Result(
            nearLimit: nearM,
            farLimit: farM,
            totalDOF: totalDOF,
            hyperfocalDistance: H / 1000,
            front: front,
            back: back
        )
    }
}
