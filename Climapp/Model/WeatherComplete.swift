//
//  WeatherComplete.swift
//  Climapp
//
//  Created by Eduardo Wasem on 10/05/22.
//

import Foundation

//Modelo que recebe os dados da api na requisição completa, pela latitude e longitude
struct WeatherComplete: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let uvi: Double
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let description: String
    let icon: String
    
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
}

struct Hourly: Codable {
    let temp: Double
    let dt: Double
    let weather: [Weather]
    
    var temperature: String {
        return String(Int(temp.rounded()))
    }
    
    var hour: String {
        return dateConvert(dateUnix: dt)
    } 
}

struct Daily: Codable {
    let dt: Double
    let temp: Temp
    let uvi: Double
    let wind_speed: Double
    let pop: Double
    let weather: [Weather]
    
    var wind: String {
        return "Vento \(Int((wind_speed * 3.6).rounded())) km/h"
    }
    
    var uv: String {
        return "UV - \(Int(uvi.rounded()))"
    }
    
    var prob: String {
        return "Probabilidade de chuva \(String(Int(pop*100))) %"
    }
    
    var day: String {
        dateConvertForDaily(dateUnix: dt)
    }
}

struct Temp: Codable {
    let min: Double
    let max: Double
    
    var temperatureMin: String {
        return "Mín. \(Int(min.rounded()))"
    }
    
    var temperatureMax: String {
        return "Máx. \(Int(max.rounded()))"
    }
}

func dateConvert(dateUnix: Double) -> String {
    let date = Date(timeIntervalSince1970: dateUnix)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT-0300") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd/MM - HH:mm" //Specify your format that you want
    return dateFormatter.string(from: date)
}

func dateConvertForDaily(dateUnix: Double) -> String {
    let date = Date(timeIntervalSince1970: dateUnix)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT-0300") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd/MM" //Specify your format that you want
    return dateFormatter.string(from: date)
}


