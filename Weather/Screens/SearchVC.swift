//
//  SearchVC.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var citiesTableView: UITableView!
    @IBOutlet private weak var citiesTableBottomConstraint: NSLayoutConstraint!
    
    private var cities = [City]() {
        didSet {
            citiesTableView.reloadData()
        }
    }
    
    var delegate: ViewControllerDelegate!
    
    private var keyboardConstraint: NSLayoutConstraint!
    
    private var searchTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchTextField()
        registerNibs()
        setupKeyboardHiding()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = self
    }
    
    private func registerNibs() {
        citiesTableView.register(UINib(nibName: CitySearchCell.reuseID, bundle: nil), forCellReuseIdentifier: CitySearchCell.reuseID)
    }
    
    // Keyboard toggle methods
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                citiesTableBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        citiesTableBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // NavigationBar buttons methods
    @IBAction private func dismissVC(_ sender: UIButton) {
        impactOccured(style: .light)
        dismiss(animated: true)
    }
    
    @IBAction private func searchTapped(_ sender: UIButton) {
        performSearch()
    }
    
    // Search methods
    private func performSearch() {
        impactOccured(style: .light)
        
        if let text = searchTextField.text, text.isEmpty {
            presentAlert(message: ErrorMessage.emptySearch)
        } else {
            tryGetCities()
        }
    }
    
    private func tryGetCities() {
        if let text = searchTextField.text, !text.isEmpty {
            Task {
                do {
                    self.cities = try await NetworkManager.shared.fetch(from: .getCities(prefx: text))
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
    
    // Textfield delay timer methods
    private func stopSearchTimer() {
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    private func startSearchTimer() {
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.tryGetCities()
        }
    }
}

// MARK: - Search Textfield Delegate
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

// MARK: - CitiesTableView Delegate&DataSource
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

