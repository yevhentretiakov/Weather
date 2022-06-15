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
    
    var cities = [City]()
    var delegate: SearchVCDelegate!
    
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
        impactOccured(style: .light)
        tryGetCities()
    }
    
    func tryGetCities() {
        if let text = searchTextField.text, !text.isEmpty {
            view.endEditing(true)
            Task {
                do {
                    self.cities = try await PlaceSearchManager.shared.fetchCities(prefix: text)
                    
                    if self.cities.isEmpty {
                        presentAlert(message: ErrorMessage.nothingFind)
                    }
                    
                    citiesTableView.reloadData()
                } catch {
                    if let error = error as? ErrorMessage {
                        presentAlert(message: error)
                    }
                }
            }
        } else {
            presentAlert(message: ErrorMessage.emptySearch)
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tryGetCities()
        return true
    }
}

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
        delegate.didSelectCity(city: city)
        dismiss(animated: true)
    }
}

