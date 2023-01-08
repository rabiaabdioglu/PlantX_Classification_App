//
//  FindViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 2.12.2022.
//

import UIKit

class FindViewController: UIViewController {
    
    let predictionsToShow = 2
    let imagePredictor = ImagePredictor()

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startupPrompts: UIStackView!
    var getImage :UIImage?
    var plantName = "BitkiAdı"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
    }
   
    
    
// Segue ile veri aktarma
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindToResult" {
            
            if let resultLabel = segue.destination as? ResultViewController { // 1
                
                let plantInfo = self.plantName.components(separatedBy: "-")
                do{ resultLabel.plantInfo.name = plantInfo[0]
                    resultLabel.plantInfo.percent = plantInfo[1]
                    resultLabel.ResultImage?.image = imageView?.image
                    
                }catch{
                    print("Missing parameter.")

                }
            }
        }}
    
// segue işlemleri
    @IBAction func FindToResult(plants button : UIButton){
        
        performSegue(withIdentifier: "FindToResult", sender: self)
        
    }
    @IBAction func dismissBtnPressed() {
        dismiss(animated: true) {
        }
    }
}


// kullanıcı seçim sorgulama
 extension FindViewController {
      
     @IBAction func isCapture() {
         
         present(cameraPicker, animated: false)
         
     }

        /// The method the storyboard calls when the user take photo
        @IBAction func selectFromLibrary() {
            present(photoPicker, animated: false)
       

        }
}


// MARK: Görüntü alma ve güncelleme
extension FindViewController {
  
    /// - Görüntü alma veya seçme
 func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image

        }
    }

    func userSelectedPhoto(_ photo: UIImage) {
        updateImage(photo)
        updatePredictionLabel("Making predictions for the photo...")

        DispatchQueue.global(qos: .userInitiated).async {
        self.classifyImage(photo)

        }
    }

    // bitki adı label güncelleme
     func updatePredictionLabel(_ message: String) {
         DispatchQueue.main.async {
             self.predictionLabel.text = message
             self.plantName = message
         }}

}


// MARK: Görüntü sınıflandırma ve label alma işlemleri

extension FindViewController {
    
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }

    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
     
        
        guard let prediction = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(prediction)
        let predictionString = formattedPredictions.joined(separator: "\n")
        updatePredictionLabel(predictionString)
  
        
    }


    // Bitki adı ve yüzdelik oranları alma

    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification
            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))  }
            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
