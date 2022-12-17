//
//  BMIcellTableViewCell.swift
//  BMI_Calculator
//
//  Created by Hisham Abu Sanimeh on 16/12/2022.
//

import UIKit

class BMIcellTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var newDate: UILabel!
    @IBOutlet weak var newWeight: UILabel!
    @IBOutlet weak var newBMI: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //User Interface builder function
    static func nib() -> UINib {
        return UINib(nibName: "BMIcellTableViewCell", bundle: nil)
    }
    
    public func config(BMI: Float, Weight: Float, date: Date)
    {
        let date = Date()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "YY/MM/dd"
        
        newDate.text = dateFormatter.string(from: date)
        newWeight.text = NSString(format: "%.2f", Weight) as String
        newBMI.text = NSString(format: "%.2f", BMI) as String
        
    }
    
}
