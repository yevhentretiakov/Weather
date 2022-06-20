//
//  SearchVC.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities = [City]() {
        didSet {
            citiesTableView.reloadData()
        }
    }
    
    var delegate: ViewControllerDelegate!
    
    var searchTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        citiesTableView.register(UINib(nibName: CitySearchCell.reuseID, bundle: nil), forCellReuseIdentifier: CitySearchCell.reuseID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        impactOccured(style: .light)
        dismiss(animated: true)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        performSearch()
    }
    
    func performSearch() {
        impactOccured(style: .light)
        
        if let text = searchTextField.text, text.isEmpty {
            presentAlert(message: ErrorMessage.emptySearch)
        } else {
            tryGetCities()
        }
    }
    
    func tryGetCities() {
        if let text = searchTextField.text, !text.isEmpty {
            Task {
                do {
                    self.cities = try await NetworkManager.shared.fetch(from: .getCities(prefx: text))
                    
                    if self.cities.isEmpty {
                        presentAlert(message: ErrorMessage.nothingFind)
                    }
                } catch {
                    if let error = error as? ErrorMessage {
                        presentAlert(message: error)
                    }
                }
            }
        } else {
            if !cities.isEmpty {
                self.cities.removeAll()
            }
        }
    }
    
    func stopSearchTimer() {
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    func startSearchTimer() {
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.tryGetCities()
        }
    }
}

// MARK: -
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchTimer != nil {
            stopSearchTimer()
        }
        
        startSearchTimer()
    }
}

// MARK: -
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: CitySearchCell.reuseID, for: indexPath) as! CitySearchCell
        
        let city = cities[indexPath.row]
        cell.set(city: city)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        impactOccured(style: .light)
        let city = cities[indexPath.row]
        let adminArea = city.localizedName ?? city.name
        let country = city.country.localizedName ?? city.country.name
        let coordinate = city.coordinates
        
        let area = Area(adminArea: adminArea, country: country, coordinate: coordinate)
        delegate.didSelectArea(area: area)
        dismiss(animated: true)
    }
}

