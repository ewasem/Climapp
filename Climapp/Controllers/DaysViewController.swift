//
//  DaysViewController.swift
//  Climapp
//
//  Created by Eduardo Wasem on 14/05/22.
//

import UIKit

class DaysViewController: UIViewController {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var days: [Daily] = []
    var cityLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        city.text = cityLabel
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DaysViewCell", bundle: nil), forCellReuseIdentifier: "daysCell")
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

extension DaysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "daysCell", for: indexPath) as! DaysViewCell
        cell.dayLabel.text = days[indexPath.row].day
        cell.imageWeather.image = UIImage(systemName: days[indexPath.row].weather[0].conditionName)
        cell.maxTempLabel.text = "\(days[indexPath.row].temp.temperatureMax)°"
        cell.minTempLabel.text = "\(days[indexPath.row].temp.temperatureMin)°"
        cell.rainProbLabel.text = days[indexPath.row].prob
        cell.uvLabel.text = days[indexPath.row].uv
        cell.descriptionLabel.text = days[indexPath.row].weather[0].description.capitalized
        cell.windLabel.text = days[indexPath.row].wind
        return cell
    }
    
    
}
