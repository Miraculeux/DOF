import Foundation

/// All DOF‑related math lives here.
final class DOFCalculator {
    
    /// Parameters that the user enters
    struct Parameters {
        let aperture: Double          // f‑stop (e.g. 2.8, 5.6)
        let focalLength: Double       // mm (e.g. 50)
        let sensorCropFactor: CropFactor
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
        let circleOfConfusion = circleOfConfusion(cropFactor: params.sensorCropFactor)
        
        // 1. Effective focal length (adjust for crop factor)
        // let factorLength = params.focalLength * focalLength(cropFactor: params.sensorCropFactor)
        let factorLength = params.focalLength
        
        // 2. Hyperfocal distance (meters)
        let hyperFocalDistance = (factorLength * factorLength) / (params.aperture * circleOfConfusion) + factorLength
        
        // 3. Near and far limits
        let distanceMM = params.subjectDistance * 1000
        let near  = (distanceMM * (hyperFocalDistance - factorLength)) / (hyperFocalDistance + distanceMM - 2 * factorLength)
        
        var far = Double.infinity
        if (distanceMM < hyperFocalDistance){
            far = (distanceMM * (hyperFocalDistance - factorLength)) / (hyperFocalDistance - distanceMM)
        }
        
        // Convert back to meters
        let nearM = near / 1000.0
        let farM = far.isInfinite ? Double.infinity : far / 1000.0
        // 4. Total DOF
        let totalDOF = farM.isInfinite ? Double.infinity : farM - nearM
        
        let front = max(0, distanceMM - near) / 1000
        let back = far.isInfinite ? Double.infinity : max(0, far - distanceMM) / 1000
        
        return Result(
            nearLimit: nearM,
            farLimit: farM,
            totalDOF: totalDOF,
            hyperfocalDistance: hyperFocalDistance / 1000,
            front: front,
            back: back
        )
    }
    
    static func focalLength(cropFactor: CropFactor) -> Double{
        switch cropFactor{
        case .fullFrame:
            return 1.0
        case .canonAPSC:
            return 1.6
        case .sonyAPSC:
            return 1.5
        }
    }
    
    static func circleOfConfusion(cropFactor: CropFactor) -> Double{
        switch cropFactor{
        case .fullFrame:
            return 0.03
        case .canonAPSC:
            return 0.019
        case .sonyAPSC:
            return 0.02
        }
    }
}
