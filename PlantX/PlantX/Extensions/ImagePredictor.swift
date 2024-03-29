//  PlantX
//
//  Created by Rabia Abdioğlu on 20.12.2022.
//
import Vision
import UIKit


class ImagePredictor {

    static func createImageClassifier() -> VNCoreMLModel {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? PlantX3(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }


    private static let imageClassifier = createImageClassifier()

    struct Prediction {
       
        let classification: String
        let confidencePercentage: String    }

    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()

    private func createImageClassificationRequest() -> VNImageBasedRequest {
        // Create an image classification request with an image classifier model.
        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier,
                                                         completionHandler: visionRequestHandler)

        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }

    /// Generates an image classification prediction for a photo.
    /// - Parameter photo: An image, typically of an object or a scene.
    /// - Tag: makePredictions
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }

        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        let requests: [VNRequest] = [imageClassificationRequest]

        // Start the image classification request.
        try handler.perform(requests)
    }

    
      private func visionRequestHandler(_ request: VNRequest, error: Error?) {
          // Remove the caller's handler from the dictionary and keep a reference to it.
          guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
              fatalError("Every request must have a prediction handler.")
          }

          // Start with a `nil` value in case there's a problem.
          var predictions: [Prediction]? = nil

          // Call the client's completion handler after the method returns.
          defer {
              // Send the predictions back to the client.
              predictionHandler(predictions)
          }

          // Check for an error first.
          if let error = error {
              print("Vision image classification error...\n\n\(error.localizedDescription)")
              return
          }

          // Check that the results aren't `nil`.
          if request.results == nil {
              print("Vision request had no results.")
              return
          }

          // Cast the request's results as an `VNClassificationObservation` array.
          guard let observations = request.results as? [VNClassificationObservation] else {
              // Image classifiers, like MobileNet, only produce classification observations.
              // However, other Core ML model types can produce other observations.
              // For example, a style transfer model produces `VNPixelBufferObservation` instances.
              print("VNRequest produced the wrong result type: \(type(of: request.results)).")
              return
          }

          // Create a prediction array from the observations.
          predictions = observations.map { observation in
              // Convert each observation into an `ImagePredictor.Prediction` instance.
              Prediction(classification: observation.identifier,
                         confidencePercentage: observation.confidencePercentageString)
          }
      }
}
