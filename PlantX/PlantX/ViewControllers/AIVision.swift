//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//
import Foundation
import Vision

final class AIVision {

    /// The pixel buffer being held for analysis; used to serialize Vision requests.
    var currentBuffer: CVPixelBuffer? {
        didSet {
            if currentBuffer != nil {
                classifyCurrentImage()
            }
        }
    }

    // Vision görüntü sınıflandırma işlemleri

    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // Ml model ekleme
            let model = try VNCoreMLModel(for: PlantX3().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })

            // Görselin orta bölümünden kırpma. Eğitim için gerekli oranlarda görsel elde edilir
            request.imageCropAndScaleOption = .centerCrop

            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    // Görsel etiketleme
    private lazy var labels : [String] = {
        guard let path = Bundle.main.path(forResource: "label", ofType: "txt"),
            let content = try? String(contentsOfFile: path, encoding: .utf8) else {
                assertionFailure("Parsing label.txt error")
                return [String]()
        }
        
        
        
        
        let lines = content.components(separatedBy: "\n")
        var array = [String]()
        for line in lines {
            let element = line.components(separatedBy: ":")
            if let value = element.last {
       
                array.append(value)
            }
        }
        
        return array
    }()
    private var inference : ((String, Double) -> Void)? = nil

    init(inference: @escaping (String, Double) -> Void) {
        self.inference = inference
    }

    
    private func classifyCurrentImage() {
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentBuffer!)


        DispatchQueue(label: "com.PlantX.serialVisionQueue").async {
            do {
                // Release the pixel buffer when done, allowing the next buffer to be processed.
                defer { self.currentBuffer = nil }
                try requestHandler.perform([self.classificationRequest])
            } catch {
                print("Error: Vision request failed with error \"\(error)\"")
            }
        }
    }


    private func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results,
            let classifications = results as? [VNCoreMLFeatureValueObservation] else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
        }
        guard let bestResult = classifications.first(where: { result in result.confidence > 0.5 }),

            let featureArray = bestResult.featureValue.multiArrayValue else {
                print("bestResult or featureArray not available")
                return
        }
        let length = featureArray.count
        let doublePtr = featureArray.dataPointer.bindMemory(to: Double.self, capacity: length)
        let doubleBuffer = UnsafeBufferPointer(start: doublePtr, count: length)
        let output = Array(doubleBuffer)
        if let maxConfidence = output.max(),
            let maxIndex = output.firstIndex(of: maxConfidence) {
            if maxIndex < labels.count && maxConfidence > 0.7 {
                let bestLabelElement = labels[maxIndex]
                self.inference?(bestLabelElement, maxConfidence)
                return
            }
        }
    }
    
    
    
    
}
