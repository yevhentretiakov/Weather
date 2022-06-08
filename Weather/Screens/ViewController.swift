//
//  ViewController.swift
//  Weather
//
//  Created by user on 08.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeWeatherCollectionView: UICollectionView!
    @IBOutlet weak var dayWeatherTableView: UITableView!
    
    var timeWeatherArray = ["18", "3", "3", "3", "3", "3", "3", "3", "3", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeWeatherCollectionView.register(UINib.init(nibName: "TimeWeatherCell", bundle: nil), forCellWithReuseIdentifier: TimeWeatherCell.reuseID)
        dayWeatherTableView.register(UINib.init(nibName: "DayWeatherCell", bundle: nil), forCellReuseIdentifier: DayWeatherCell.reuseID)
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return timeWeatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = timeWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: TimeWeatherCell.reuseID, for: indexPath) as! TimeWeatherCell
      
        cell.backgroundColor = .systemRed

        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dayWeatherTableView.dequeueReusableCell(withIdentifier: DayWeatherCell.reuseID, for: indexPath) as! DayWeatherCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
