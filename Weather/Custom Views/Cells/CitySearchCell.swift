//
//  CitySearchCell.swift
//  Weather
//
//  Created by user on 12.06.2022.
//

import UIKit

class CitySearchCell: UITableViewCell {
    
    static let reuseID = "CitySearchCell"
    
    @IBOutlet private weak var delimiterLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            layer.masksToBounds = false
            layer.shadowColor = UIColor(named: AppColor.lightBlue.rawValue)?.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = .zero
            layer.shadowRadius = 15
            layer.zPosition = 50
            
            cityNameLabel.textColor = UIColor(named: AppColor.blue.rawValue)
            delimiterLabel.textColor = UIColor(named: AppColor.blue.rawValue)
            countryNameLabel.textColor = UIColor(named: AppColor.blue.rawValue)
        } else {
            layer.shadowOpacity = 0.0
            layer.zPosition = 1
            
            cityNameLabel.textColor = UIColor.black
            delimiterLabel.textColor = UIColor.black
            countryNameLabel.textColor = UIColor.black
        }
    }
    
    func set(city: City) {
        cityNameLabel.text = city.localizedName ?? city.name
        countryNameLabel.text = city.country.localizedName ?? city.country.name
    }
}
