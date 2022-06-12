//
//  TimeWeatherCell.swift
//  Weather
//
//  Created by user on 08.06.2022.
//

import UIKit

class TimeWeatherCell: UICollectionViewCell {
    
    static let reuseID = "TimeWeatherCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(hour: Hour, index: Int) {
        if index < 10 {
            timeLabel.text = "0\(index)"
        } else {
            timeLabel.text = String(index)
        }
        weatherImage.image = UIImage(systemName: hour.image)
        tempLabel.text = String(format: "%.0f", hour.temp)
    }
}
