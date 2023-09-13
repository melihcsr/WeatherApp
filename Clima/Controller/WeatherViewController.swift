

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextfield.delegate = self
    }
    
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}


extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextfield.endEditing(true)
        
      
        print(searchTextfield.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextfield.text!)
        searchTextfield.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextfield.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let city = searchTextfield.text {
            weatherManager.completeUrl(city: city)
        }
        if searchTextfield.text != "" {
            return true
        }
        else{
            searchTextfield.placeholder = "Type Something"
            return false
        }
    }
}


extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager,weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.getConditionName(weatherId: weather.conditionId))
            self.cityLabel.text = weather.cityName
        }
      
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longtitude = location.coordinate.longitude
            weatherManager.fetchWeather(latidute: latitude, longitute: longtitude)
           
            
            print(longtitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

