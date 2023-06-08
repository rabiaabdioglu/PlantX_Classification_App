//
//  HomeViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController  {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var apiId = "xxxxxxxxxxxxx"
    var lat = 40.746213
    var lon = 30.034257
    
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        getWeather()
     
       }
    
    
    
    
    
    
    // MARK: Segue sayfalar arası yönlendirme
    @IBAction func HomeToMyPlant(plants button : UIButton){
        
        performSegue(withIdentifier: "HomeToMyPlant", sender: self)
        
    }
    @IBAction func HomeToHistory(plants button : UIButton){
        
        performSegue(withIdentifier: "HomeToHistory", sender: self)
        
    }
    @IBAction func HomeToFind(plants button : UIButton){
        
        performSegue(withIdentifier: "HomeToFind", sender: self)
        
    }
    
}


extension HomeViewController
{
   
    func getLocation(){
        
        locationManager.requestWhenInUseAuthorization()
        var currentLoc : CLLocation!
      
            
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
               CLLocationManager.authorizationStatus() == .authorizedAlways) {
                currentLoc = locationManager.location
                
            }
        if currentLoc != nil {
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]?
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // İlçe adı
                if placeMark != nil{
                    if let city = placeMark.addressDictionary?["City"] as? NSString
                    { self.cityNameLabel.text = city as String?
                    }
                    else
                    {
                        print("Error : Weather api")}
                    
                }
                else{print("Placemark is nil")}
                
                
            }}
        
        else {
            print("Error : Cant get location")
        }
        
        
    }

    
    func getWeather(){
        var temp : Double?
        let  weatherUrl = URL(string:  "https://api.openweathermap.org/data/2.5/weather?lat=\(self.lat)&lon=\(self.lon)&appid=\(self.apiId)"
        )
        let session = URLSession.shared
        let task =  session.dataTask(with: weatherUrl!) { data, response , error in
            if error != nil {
                print("Error : weather api")}
            else {
                if data != nil {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any?]
                        
                        DispatchQueue.main.async {
                            if let main = jsonResponse!["main"] as? [String : Any?] {
                                if let tempLabel = main["temp"] as? Double {
                                    temp = Double(tempLabel-272.15).rounded()
                                    self.tempatureLabel.text = String(temp!)
                                } }
                            if let main = jsonResponse!["wind"] as? [String : Any?] {
                                if let windLabel = main["speed"] as? Double {
                                    self.windLabel.text = String(windLabel)  } }
                            if let main = jsonResponse!["main"] as? [String : Any?] {
                                if let humidityLabel = main["humidity"] as? Int {
                                 
                                    self.humidityLabel.text = String("%\(humidityLabel)")  } }
                         }
                        
                        
                    } catch{
                        
                    }
                    
                }
            }}
        task.resume()
    }
}

