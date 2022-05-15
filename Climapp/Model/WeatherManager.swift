//
//  WeatherManager.swift
//  Climapp
//
//  Created by Eduardo Wasem on 09/05/22.
//

import Foundation

//Protocolo de ligação com a NowViewController
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func failed(error: Error)
}

//Struct responsável pela ligação com a api
struct WeatherManager {
    
    // URL da API que recebe os dados completos do clima pela latitude e longitude
    // Como não tem procura por nome, tive que criar uma segunda ligação que usei para receber
    // os dados de latitude e longitude e o nome da cidade.
    let weatherUrl = "https://api.openweathermap.org/data/2.5/onecall?lang=pt_br&units=metric&appid=c1febd6c92c29223ac852098ce493882"
    
    // URL da API que usei para receber o nome da cidade e a latitude e longitude
    let weatherNow = "https://api.openweathermap.org/data/2.5/weather?lang=pt_br&units=metric&appid=c1febd6c92c29223ac852098ce493882"
    
    var delegate: WeatherManagerDelegate?
    
    //recebe o nome vindo da TextField, processa em uma url completa e envia para a função de requisição da API
    mutating func getWeatherNow(city: String) {
        let cityName = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = "\(weatherNow)&q=\(cityName!)"
        requestWeather(urlString, false, "")
    }
    
    func weatherUrlwithLatLon(_ lat: Double, _ lon: Double, _ city: String) {
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        requestWeather(urlString, true, city)
    }
    
    //Função responsável por fazer a requisição para a API, como tenho 2 tipos de requisição,
    //por nome ou por latitude e longitude, criei a variável "complete" que indica qual requisição fazer
    func requestWeather(_ urlString: String, _ complete: Bool, _ city: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.failed(error: error!)
                    return
                }
                if let weatherData = data {
                    if complete {
                        if let weather = parseJSONComplete(weatherData, city) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    } else {
                        self.parseJSONNow(weatherData)
                    }
                }
            }
            task.resume()
        }
    }
    
    //Função que recebe o retorno da cidade, latitude e longitude da API e faz uma nova reuisição
    //agora com a latitude e longitude para receber os dados completos.
    func parseJSONNow(_ weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherNowData.self, from: weatherData)
            let city = decodedData.name
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
            requestWeather(urlString, true, city)
        } catch {
            delegate?.failed(error: error)
        }
    }
    
    //Função que recebe os dados completos 
    func parseJSONComplete(_ weatherData: Data, _ city: String) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherComplete.self, from: weatherData)
            let sunrise = decodedData.current.sunrise
            let sunset = decodedData.current.sunset
            let temp = decodedData.current.temp
            let feels_like = decodedData.current.feels_like
            let humidity = decodedData.current.humidity
            let uvi = decodedData.current.uvi
            let wind_speed = decodedData.current.wind_speed
            let description = decodedData.current.weather[0].description
            let icon = decodedData.current.weather[0].icon
            let hourly = decodedData.hourly
            let daily = decodedData.daily
            
            let weather = WeatherModel(city: city, sunrise: sunrise, sunset: sunset, temp: temp, feels_like: feels_like, humidity: humidity, uvi: uvi, wind_speed: wind_speed, description: description, icon: icon, hourly: hourly, daily: daily)
            
            
            return weather
            
        } catch {
            delegate?.failed(error: error)
            return nil
        }
    }
    
   
}
