//
//  CustomCollectionView.swift
//  Climapp
//
//  Created by Eduardo Wasem on 11/05/22.
//

import UIKit

class CustomCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WeatherManagerDelegate {
    
    let collectionView = UICollectionView.self
    var hour = ""
    var temperature = ""
    var descript = ""
    var image = ""
    var weatherHour = [Hourly(temp: 0, dt: 0, weather: [Weather(description: "", icon: "")])]
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                self.weatherHour = weather.hourly
                collectionView.reloadData()
            }
        }}
    
    func failed(error: Error) {
        print(error)
    }
    
    
    
    var weatherManager = WeatherManager()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! HourViewCell
        cell.temperatureLabel.text = "\(weatherHour[indexPath.row].temp ?? 0)°"
        return cell
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
        self.delegate = self
        self.weatherManager.delegate = self
        
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return weatherHour.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    
}
