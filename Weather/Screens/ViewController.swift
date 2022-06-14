//
//  ViewController.swift
//  Weather
//
//  Created by user on 08.06.2022.
//

import UIKit
import CoreLocation

protocol SearchVCDelegate {
    func didSelectCity(city: City)
}

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
    var currentCity = City(name: "Kyiv", country: Country(name: "Ukraine", localizedName: nil), localizedName: nil)
    
    var weatherDays = [Day]()
    var hoursInfo = [Hour]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.delegate = self
        LocationManager.shared.start()
        
        specifyWeatherOnLaunch()
        
        timeWeatherCollectionView.register(UINib.init(nibName: TimeWeatherCell.reuseID, bundle: nil), forCellWithReuseIdentifier: TimeWeatherCell.reuseID)
        dayWeatherTableView.register(UINib.init(nibName: DayWeatherCell.reuseID, bundle: nil), forCellReuseIdentifier: DayWeatherCell.reuseID)
    }
    
    @IBAction func toSearchTapped(_ sender: Any) {
        impactOccured(style: .light)
        LocationManager.shared.stop()
        performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let firstVC = segue.destination as? SearchVC {
            firstVC.delegate = self
        }
    }
    
    func specifyWeatherOnLaunch() {
        localizeCity()
        getWeatherByGeo()
    }
    
    func getWeatherByGeo() {
        Task {
            do {
                if let cityByGeo = try await LocationManager.shared.fetchCity() {
                    fetchWeather(city: cityByGeo)
                    LocationManager.shared.stop()
                } else {
                    fetchWeather(city: currentCity)
                }
            } catch {
                print("error")
            }
        }
    }
    
    func localizeCity() {
        let locale = Locale.current.languageCode
        
        if locale == "ru" {
            currentCity.localizedName = "Киев"
        } else if locale == "uk" {
            currentCity.localizedName = "Київ"
        }
    }
    
    func fetchWeather(city: City) {
        Task {
            do {
                self.weatherDays = try await WeatherManager.shared.fetchWeather(cityName: city.name)
                
                currentCity = city
                updateUI(date: Date())
               
                dayWeatherTableView.reloadData()
                timeWeatherCollectionView.reloadData()
                selectFirstRow()
            } catch {
                print("Error")
            }
        }
    }
    
    func updateUI(date: Date) {
        
        dateLabel.text = date.extract("E, dd MMMM")
        
        let day = weatherDays[activeDay]
        hoursInfo = day.hours.sorted(by: { $0.datetimeEpoch < $1.datetimeEpoch })
        
        cityNameLabel.text = currentCity.localizedName ?? currentCity.name
        
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

extension ViewController: SearchVCDelegate {
    
    func didSelectCity(city: City) {
        
        fetchWeather(city: city)
    }
}

extension ViewController: LocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        getWeatherByGeo()
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
        
        impactOccured(style: .light)
        
        activeDay = indexPath.row
        if let date = Date().date(byAdding: .day, value: indexPath.row) {
            self.updateUI(date: date)
        }
        timeWeatherCollectionView.reloadData()
    }
}

