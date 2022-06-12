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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        citiesTableView.register(UINib(nibName: CitySearchCell.reuseID, bundle: nil), forCellReuseIdentifier: CitySearchCell.reuseID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        if let text = searchTextField.text, !text.isEmpty {
            Task {
                do {
                    self.cities = try await PlaceSearchManager.shared.fetchCities(prefix: text)
                    citiesTableView.reloadData()
                } catch {
                    print("Error")
                }
            }
        }
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
}
