//
//  CitySearchCell.swift
//  Weather
//
//  Created by user on 12.06.2022.
//

import UIKit

class CitySearchCell: UITableViewCell {
    
    static let reuseID = "CitySearchCell"

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func set(city: City) {
        cityNameLabel.text = city.name
        countryNameLabel.text = city.country.name
    }
}
