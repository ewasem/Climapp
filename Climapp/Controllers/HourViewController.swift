//
//  HourViewController.swift
//  Climapp
//
//  Created by Eduardo Wasem on 13/05/22.
//

import UIKit

class HourViewController: UIViewController {
    
    var hour: [Hourly] = []
    var city = ""
    var weatherManager = WeatherManager()
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HourViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.cityLabel.text = city
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HourViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HourViewCell
        cell.imageWeather.image = UIImage(systemName: hour[indexPath.row].weather[0].conditionName)
        cell.hourLabel.text = hour[indexPath.row].hour
        cell.tempLabel.text = "\(hour[indexPath.row].temperature)°"
        cell.descriptionLabel.text = hour[indexPath.row].weather[0].description
        
        return cell
    }
    
    
}
