//
//  WeatherModel.swift
//  Climapp
//
//  Created by Eduardo Wasem on 10/05/22.
//

import Foundation

//Struct que serve de modelo para os dados que foram recebidos e os converte quando necessário
//para uma string com o formato correto
struct WeatherModel {
    let city: String
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let uvi: Double
    let wind_speed: Double
    let description: String
    let icon: String
    let hourly: [Hourly]
    let daily: [Daily]
    
    //Transforma a data que vem em formato UNIX para o formato que preciso apresentar na tela
    var sunriseText: String {
        return dateConvert(dateUnix: sunrise)
    }
    
    //Transforma a data que vem em formato UNIX para o formato que preciso apresentar na tela
    var sunsetText: String {
        return dateConvert(dateUnix: sunset)
    }
    
    //Arredonda a double recebida e tansforma em string
    var feels_likeTemperature: String {
        return String(Int(feels_like.rounded()))
    }
    
    //Arredonda a double recebida e tansforma em string
    var temperature: String {
        return String(Int(temp.rounded()))
    }
    
    //comverte m/s para km/h, arredonda a double recebida e tansforma em string
    var wind: String {
        return "\(Int((wind_speed * 3.6).rounded())) km/h"
    }
    
    //Transforma o ícone que vem da api para uma string com o nome utilizado
    //nos símbolos SF que combina com o clima
    var conditionName: String {
        switch icon {
        case "01d": return "sun.max"
        case "01n": return "moon.stars"
        case "02d": return "cloud.sun"
        case "02n": return "cloud.moon"
        case "03d": return "cloud"
        case "03n": return "cloud"
        case "04d": return "smoke"
        case "04n": return "smoke"
        case "09d": return "cloud.heavyrain"
        case "09n": return "cloud.heavyrain"
        case "10d": return "cloud.sun.rain"
        case "10n": return "cloud.moon.rain"
        case "11d": return "cloud.bolt.rain"
        case "11n": return "cloud.bolt.rain"
        case "13d": return "snowflake"
        case "13n": return "snowflake"
        case "50d": return "cloud.fog"
        case "50n": return "cloud.fog"
        default: return "cloud.sun"
        }
        
    }
    
    //Função de converção da data Unix em string no formato correto
    func dateConvert(dateUnix: Double) -> String {
        let date = Date(timeIntervalSince1970: dateUnix)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT-0300") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
}
