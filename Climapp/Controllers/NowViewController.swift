//
//  ViewController.swift
//  Climapp
//
//  Created by Eduardo Wasem on 06/05/22.
//

import UIKit
import CoreLocation

// Classe NowViewControler, que recebe os dados do clima atual.

class NowViewController: UIViewController {
    @IBOutlet weak var citySearch: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var menuButton: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var sensationLabel: UILabel!
    @IBOutlet weak var umidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var hour: [Hourly] = []
    var days: [Daily] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        locationManager.delegate = self
        weatherManager.delegate = self
        citySearch.delegate = self
        citySearch.layer.cornerRadius = citySearch.frame.size.height/2
        citySearch.clipsToBounds = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.cityLabel.text = ""
        self.temperatureLabel.text = ""
        self.uvLabel.text = ""
        self.sensationLabel.text = ""
        self.umidityLabel.text = ""
        self.windLabel.text = ""
        self.sunriseLabel.text = ""
        self.sunsetLabel.text = ""
        self.descriptionLabel.text = ""
        
        
    }
    
    //Botão que vai para a HourViewController, que apresenta o clima das próximas 48 horas
   
    
    @IBAction func hourButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHour", sender: self)
    }
    
    
    //Botão que vai para a tela DaysViewController, que mostra o clima para os próximos 7 dias
    @IBAction func daysButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToDays", sender: self)
    }
    
    
    @IBAction func locationButton(_ sender: Any) {
        locationManager.requestLocation()
        activityIndicator.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHour" {
            let destinationVC = segue.destination as! HourViewController
            destinationVC.hour = self.hour
            destinationVC.city = self.cityLabel.text!
        }
        
        if segue.identifier == "goToDays" {
            let destinationVC = segue.destination as! DaysViewController
            destinationVC.days = self.days
            destinationVC.cityLabel = self.cityLabel.text!
        }
    }
    
    
    
}

//MARK: - UITextFieldDelegate
// Extensão responsável pelo controle do textfield de procura por cidade
extension NowViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        citySearch.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if citySearch.text != "" {
            return true
        } else {
            citySearch.placeholder = "Digite o nome de uma cidade"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = citySearch.text {
            self.activityIndicator.startAnimating()
            weatherManager.getWeatherNow(city: city)
        }
        citySearch.text = ""
        citySearch.placeholder = "Procurar"
    }
}

//MARK: - WeatherManagerDelegate
//Extensão que faz a ligação com o WeatherManager, que recebe os dados vindo da api e atualiza na tela

extension NowViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = "\(weather.temperature)°"
            self.uvLabel.text = String(Int(weather.uvi.rounded()))
            self.sensationLabel.text = "\(weather.feels_likeTemperature)°"
            self.umidityLabel.text = "\(weather.humidity)%"
            self.windLabel.text = weather.wind
            self.sunriseLabel.text = weather.sunriseText
            self.sunsetLabel.text = weather.sunsetText
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.descriptionLabel.text = weather.description.capitalized
            self.hour = weather.hourly
            self.days = weather.daily
        }
    }
    func failed(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
//Extensão responsável pela localização do aparelho

extension NowViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let ceo: CLGeocoder = CLGeocoder()
            
            let loc: CLLocation = CLLocation(latitude:lat, longitude: lon)
            
            ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                if (error != nil)
                {
                    print("erro ao receber a localização: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    DispatchQueue.main.async {
                        self.weatherManager.weatherUrlwithLatLon(lat, lon, pm.locality!)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("deu merda \(error)")
    }
}





