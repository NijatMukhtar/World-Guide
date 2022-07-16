//
//  Models.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 28.06.22.
//

import Foundation

struct CountryModel: Codable{
    let name: String
    let flag: String
    let cities: [CityModel]
}

struct CityModel: Codable{
    let name:String
    let image: String
    let places:[PlaceModel]
}
struct PlaceModel: Codable{
    let image: [String]
    let text: String
    let name: String
    let latitude: Double
    let longitude: Double
}

struct Credentials: Codable{
    let name: String
    let surname: String
    let email: String
    let password: String
}
