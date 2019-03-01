//
//  ViewController.swift
//  WeatherApp
//
//  Created by zhihao li on 2/16/19.
//  Copyright © 2019 zhihao li. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

let API_URL = "http://api.openweathermap.org/data/2.5/weather"
let appid = "0e604e8bb5ff63a664f1d0f8a972ff99"

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityProtocol {
    func changeCityFunc(cityName: String) {
        print("user selected \(cityName)")
        let params: [String:String] = ["q": cityName, "appid": appid]
        GetWeatherData(url: API_URL, params: params )
    }

    
    @IBOutlet weak var lbl_cityName: UILabel!
    @IBOutlet weak var lbl_weather: UILabel!
    
    @IBOutlet weak var lbl_temperature: UILabel!

    @IBAction func changeCity_button_press(_ sender: UIButton) {
        performSegue(withIdentifier: "ChangeCitySegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let changeCityController = segue.destination as! ChangeCityViewController
        changeCityController.delegate = self
    }
    
    let locationManager = CLLocationManager()
    let weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let lat = String(location.coordinate.latitude)
            let lng = String(location.coordinate.longitude)
            
            print("lat: \(lat) lng: \(lng)")
            let params: [String:String] = ["lat": lat, "lon": lng, "appid": appid ]
            
            GetWeatherData(url: API_URL, params: params )
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        self.lbl_cityName.text = "--"
        self.lbl_temperature.text = "--"
        self.lbl_weather.text = "Unable to get location"
    }
    
    func GetWeatherData(url: String, params: [String: String]){
        Alamofire.request(url, method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess{
                print("Sucessfully got weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.UpdateWeatherModel(json: weatherJSON)
            }else{
                print("Fail to get weather data")
                let JSON_error = String(describing: response.result.error)
                print(JSON_error)
                
                self.lbl_cityName.text = "--"
                self.lbl_temperature.text = "--"
                self.lbl_weather.text = "Network Error"
            }
        }
    }
    
    func UpdateWeatherModel(json: JSON){
        let kelvinTemp = json["main"]["temp"].doubleValue
        weatherModel.temperature = Int(kelvinTemp - 273.15) * 9 / 5 + 32
        weatherModel.cityName = json["name"].stringValue
        weatherModel.weatherCondation = json["weather"][0]["main"].stringValue
        
        self.lbl_cityName.text = weatherModel.cityName
        self.lbl_temperature.text = String("\(weatherModel.temperature) °F")
        self.lbl_weather.text = weatherModel.weatherCondation
    }
}

