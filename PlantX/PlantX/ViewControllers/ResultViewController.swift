//
//  ResultViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 2.12.2022.
//

import UIKit
import WikipediaKit
class ResultViewController: UIViewController {

   
    @IBOutlet weak var predictionText: UITextView!
    @IBOutlet weak var ResultImage: UIImageView!
    @IBOutlet weak var predictionLabels: UILabel!
    
    var plantText = "Yükleniyor..."
    var plantInfo = (name : "Bitki bulunamadı" , percent : "%..")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.predictionText.text  = plantText
        self.predictionLabels.text = plantInfo.name
        
        fetchDataWikipedia(element: plantInfo.name)
       
        
    }
    
    // Segue işlemleri
    @IBAction func dismissBtnPressed() {
           dismiss(animated: true) {
           }
       }
    @IBAction func ResultToMyPlants(plants button : UIButton){
        
        performSegue(withIdentifier: "ResultToMyPlants", sender: self)  }
    
// Segue ile veri aktarma
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultToMyPlants" {
            
            if let resultLabel = segue.destination as? MyPlantsViewController { // 1
                resultLabel.plantName = predictionLabels.text!
                resultLabel.imageView?.image = ResultImage?.image
                resultLabel.isSaveButtonPressed = true
            }
        }
        
    }
    
    
}



// MARK: Wikipedia api ile bitki bilgisi çekme

extension ResultViewController{
    
    func fetchDataWikipedia(element: String) {
    Wikipedia.shared.requestSearchResults(method: WikipediaSearchMethod.fullText, language: WikipediaLanguage("en"), term: element) {
    (Data, error) in
    guard error == nil else { return }
    guard let resultData = Data else { return }
    for wikiData in resultData.items {
        
             
        self.predictionText.text  = wikiData.displayText
        self.predictionLabels.text = wikiData.title
        if  wikiData.imageURL != nil { self.loadImage(url: wikiData.imageURL!)   }
        else {
            
        }
        

    break
    }}}
    
    
    
    func loadImage(url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let data = try? Data(contentsOf: url) {
                   if let image = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self?.ResultImage.image = image
                       }
                   }
               }
           }
       }
    
    
    
}
