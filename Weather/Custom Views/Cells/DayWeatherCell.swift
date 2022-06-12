//
//  DayWeatherCell.swift
//  Weather
//
//  Created by user on 08.06.2022.
//

import UIKit

class DayWeatherCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherTypeIcon: UIImageView!
    
    @IBOutlet weak var degreeHelper1: UILabel!
    @IBOutlet weak var degreeHelper2: UILabel!
    
    static let reuseID = "DayWeatherCell"
    
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
            
            dayLabel.textColor = UIColor(named: AppColor.blue.rawValue)
            maxTempLabel.textColor = UIColor(named: AppColor.blue.rawValue)
            minTempLabel.textColor = UIColor(named: AppColor.blue.rawValue)
            degreeHelper1.textColor = UIColor(named: AppColor.blue.rawValue)
            degreeHelper2.textColor = UIColor(named: AppColor.blue.rawValue)
            weatherTypeIcon.tintColor = UIColor(named: AppColor.blue.rawValue)
        } else {
            layer.shadowOpacity = 0.0
            layer.zPosition = 1
            
            dayLabel.textColor = UIColor.black
            maxTempLabel.textColor = UIColor.black
            minTempLabel.textColor = UIColor.black
            degreeHelper1.textColor = UIColor.black
            degreeHelper2.textColor = UIColor.black
            weatherTypeIcon.tintColor = UIColor.black
        }
    }
    
    func set(day: Day) {
        
        dayLabel.text = day.datetimeEpoch.toDate.extract("E").uppercased()
        maxTempLabel.text = String(format: "%.0f", day.tempmax)
        minTempLabel.text = String(format: "%.0f", day.tempmin)
        
        weatherTypeIcon.image = UIImage(systemName: day.image)
    }
}
