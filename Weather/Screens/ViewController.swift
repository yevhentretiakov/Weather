//
//  ViewController.swift
//  Weather
//
//  Created by user on 08.06.2022.
//

import UIKit
import CoreLocation

protocol ViewControllerDelegate {
    func didSelectArea(area: Area)
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
    
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    
    @IBOutlet weak var currentAreaStack: UIStackView!
    
    var currentArea: Area?
    
    var dailyWeather = [DayWeather]() {
        didSet {
            updateUI(date: Date())
            reloadTimeWeatherCollectionView()
            reloadDayWeahterTableView()
        }
    }
    var hourlyWeather = [HourWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationServices()
        registerNibs()
        addGestureForAreaLabel()
    }
    
    func startLocationServices() {
        LocationManager.shared.delegate = self
        LocationManager.shared.start()
    }
    
    func registerNibs() {
        hourlyWeatherCollectionView.register(UINib.init(nibName: TimeWeatherCell.reuseID, bundle: nil), forCellWithReuseIdentifier: TimeWeatherCell.reuseID)
        dailyWeatherTableView.register(UINib.init(nibName: DayWeatherCell.reuseID, bundle: nil), forCellReuseIdentifier: DayWeatherCell.reuseID)
    }
    
    func addGestureForAreaLabel() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(toMapTapped))
        currentAreaStack.addGestureRecognizer(gesture)
    }
    
    func getWeather(area: Area) {
        Task {
            
            // The request by the name of the city can throw, in this case we make a request by the name of the country
            for (index, areaName) in area.availableNamesList.enumerated() {
                do {
                    let data: WeatherData = try await NetworkManager.shared.fetch(from: .getWeather(areaName: areaName))
                    self.currentArea = area
                    self.dailyWeather = data.days
                    break
                } catch {
                    // If current area name was last in array and thrown then show an error, else try the next area name
                    if let error = error as? ErrorMessage, index == area.availableNamesList.count - 1 {
                        presentAlert(message: error)
                    }
                }
            }
        }
    }
    
    // UI updation methods
    func updateUI(date: Date) {
        dateLabel.text = date.extract("E, dd MMMM")
        
        guard let day = dailyWeather.first(where: { $0.datetimeEpoch.toDate.isSameDayAs(date) }) else {
            return
        }
        
        hourlyWeather = day.hours.sorted(by: { $0.datetimeEpoch < $1.datetimeEpoch })
        
        if let area = currentArea, let availableName = area.availableName {
            cityNameLabel.text = availableName
        }
        
        weatherImage.image = UIImage(systemName: day.image)
        maxTempLabel.text = String(format: "%.0f", day.tempmax)
        minTempLabel.text =  String(format: "%.0f", day.tempmin)
        humidityLabel.text =  String(format: "%.0f", day.humidity)
        windSpeedLabel.text =  String(format: "%.0f", day.windspeed)
        windDirectionImage.image = UIImage(systemName: day.windImage)
    }
    
    func reloadDayWeahterTableView() {
        dailyWeatherTableView.reloadData()
        dailyWeatherTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
    }
    
    func reloadTimeWeatherCollectionView() {
        hourlyWeatherCollectionView.reloadData()
    }
    
    // NavigationBar buttons methods
    @objc func toMapTapped() {
        impactOccured(style: .light)
        performSegue(withIdentifier: "presentMapVC", sender: self)
    }
    
    @IBAction func toSearchTapped(_ sender: Any) {
        impactOccured(style: .light)
        LocationManager.shared.stop()
        performSegue(withIdentifier: "presentSearchVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.delegate = self
        } else if let mapVC = segue.destination as? MapVC {
            mapVC.delegate = self
            if let currentArea = currentArea {
                mapVC.coordinate = currentArea.coordinate
            }
        }
    }
}


// MARK: - SearchVCDelegate
extension ViewController: ViewControllerDelegate {
    
    func didSelectArea(area: Area) {
        
        getWeather(area: area)
    }
}


// MARK: -  LocationManagerDelegate
extension ViewController: LocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .denied || status == .restricted {
            LocationManager.shared.stop()
            presentAlert(message: ErrorMessage.cantGetGeo)
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            Task {
                do {
                    if let safeLocation = manager.location {
                        let area = try await LocationManager.shared.fetchArea(location: safeLocation)
                        getWeather(area: area)
                        LocationManager.shared.stop()
                    }
                } catch {
                    if let error = error as? ErrorMessage {
                        presentAlert(message: error)
                    }
                }
            }
        }
    }
}


// MARK: - HourlyWeatherCollectionView Delegate&DataSource&FlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = hourlyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: TimeWeatherCell.reuseID, for: indexPath) as! TimeWeatherCell
        
        let hour = hourlyWeather[indexPath.item]
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


// MARK: - DailyWeatherTableView Delegate&DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dailyWeatherTableView.dequeueReusableCell(withIdentifier: DayWeatherCell.reuseID, for: indexPath) as! DayWeatherCell
        
        let day = dailyWeather[indexPath.row]
        cell.set(day: day)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        impactOccured(style: .light)
        if let date = Date().date(byAdding: .day, value: indexPath.row) {
            updateUI(date: date)
            reloadTimeWeatherCollectionView()
        }
    }
}
