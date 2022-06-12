//
//  ViewController.swift
//  Weather
//
//  Created by user on 08.06.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var windDirectionImage: UIImageView!
    
    @IBOutlet weak var timeWeatherCollectionView: UICollectionView!
    @IBOutlet weak var dayWeatherTableView: UITableView!
    
    var activeDay = 0
    var defaultCity = "Kyiv"

    var weatherDays = [Day]()
    var hoursInfo = [Hour]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryToGetCityByGeo()
        
        timeWeatherCollectionView.register(UINib.init(nibName: TimeWeatherCell.reuseID, bundle: nil), forCellWithReuseIdentifier: TimeWeatherCell.reuseID)
        dayWeatherTableView.register(UINib.init(nibName: DayWeatherCell.reuseID, bundle: nil), forCellReuseIdentifier: DayWeatherCell.reuseID)
    }
    
    func tryToGetCityByGeo() {
        LocationManager.shared.start()
        Task {
            do {
                if let city = try await LocationManager.shared.fetchCityName() {
                    fetchWeather(cityName: city)
                } else {
                    fetchWeather(cityName: defaultCity)
                }
            } catch {
                print("error")
            }
        }
    }
    
    func fetchWeather(cityName: String) {
        Task {
            do {
                self.weatherDays = try await WeatherManager.shared.fetchWeather(cityName: cityName)
                updateUI(cityName: cityName, date: Date())
                dayWeatherTableView.reloadData()
                timeWeatherCollectionView.reloadData()
                selectFirstRow()
            } catch {
                print("Error")
            }
        }
    }
    
    func updateUI(cityName: String, date: Date) {
        
        dateLabel.text = date.extract("E, dd MMMM")
        
        let day = weatherDays[activeDay]
        hoursInfo = day.hours.sorted(by: { $0.datetimeEpoch < $1.datetimeEpoch })

        cityNameLabel.text = cityName
        
        weatherImage.image = UIImage(systemName: day.image)
        maxTempLabel.text = String(format: "%.0f", weatherDays[activeDay].tempmax)
        minTempLabel.text =  String(format: "%.0f", weatherDays[activeDay].tempmin)
        humidityLabel.text =  String(format: "%.0f", weatherDays[activeDay].humidity)
        windSpeedLabel.text =  String(format: "%.0f", weatherDays[activeDay].windspeed)
        windDirectionImage.image = UIImage(systemName: day.windImage)
    }
    
    func selectFirstRow() {
        
        dayWeatherTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hoursInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = timeWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: TimeWeatherCell.reuseID, for: indexPath) as! TimeWeatherCell
        
        let hour = hoursInfo[indexPath.item]
        cell.set(hour: hour, index: indexPath.item)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 75, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dayWeatherTableView.dequeueReusableCell(withIdentifier: DayWeatherCell.reuseID, for: indexPath) as! DayWeatherCell
        
        let day = self.weatherDays[indexPath.row]
        cell.set(day: day)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        activeDay = indexPath.row
        if let date = Date().date(byAdding: .day, value: indexPath.row) {
            self.updateUI(cityName: "Kyiv", date: date)
        }
        timeWeatherCollectionView.reloadData()
    }
}
