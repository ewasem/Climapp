//
//  WeatherNowData.swift
//  Climapp
//
//  Created by Eduardo Wasem on 09/05/22.
//

import Foundation

//Modelo que pega os dados da requisição da api caso seja feita a procura por nome
struct WeatherNowData: Codable {
    let name: String
    let coord: Coord
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}
