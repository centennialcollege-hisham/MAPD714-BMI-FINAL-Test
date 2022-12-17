//
//  ViewController.swift
//  Filename: BMI_Calculator
//  Author     : Hisham Abu Sanimeh
//  Student Id : 301289364
//  Date       : Dec 16 2022
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //variables initialization
    var Uname: String = ""
    var Uage: Int = 0
    var Ugender: String = ""
    public var Uweight: Float = 0
    public var Uheight: Float = 0
    public var date = Date()

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Weight: UITextField!
    @IBOutlet weak var Height: UITextField!
    @IBOutlet weak var Bmi: UILabel!
    @IBOutlet weak var categoryResult: UILabel!
    @IBOutlet weak var Unit: UISwitch!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: User?
    override func viewDidLoad() {
           super.viewDidLoad()
        do {
            self.user = try context.fetch(NSFetchRequest<User>(entityName: "User")).last
            fillUser()
        }catch {
            print(error)
        }
        
    }
    
//    set defualt value by db 
    func fillUser() {
        guard let user = self.user else { return }
        Name.text = user.name
        Age.text = "\(user.age)"
        Gender.text = user.gender
        Weight.text = "\(user.weight)"
        Height.text = "\(user.height)"
    }

    
    @IBAction func Calculate(_ sender: UIButton)
    {
        //stores text input from textfield in variables
        Uname = Name.text!
        Uage = (Age.text! as NSString).integerValue
        Ugender = Gender.text!
        Uweight = (Weight.text! as NSString).floatValue
        Uheight = (Height.text! as NSString).floatValue
        
        let finalBmi: Float
        
        if Unit.isOn
        {
            //function to calculate BMI in Metric units
            finalBmi = Uweight/(Uheight*Uheight)
        }
        else
        {
            //function to calculate BMI in Imperial units
            finalBmi = (Uweight*703)/(Uheight*Uheight)
        }
        
        //stores calculated bmi value in BMI variable at 2 decimal places
        let BMI = NSString(format: "%.2f", finalBmi) as String
        Bmi.text = BMI
        
        date = Date()
        
        //advice text editor function based on range
        if (finalBmi < 16)
        {
            categoryResult.text = "Severe Thinness"
        }
        else if(finalBmi >= 16 && finalBmi <= 17)
        {
            categoryResult.text = "Modrate Thinness"
        }
        else if(finalBmi >= 17 && finalBmi <= 18.5)
        {
            categoryResult.text = "Mild Thinness"
        }
        else if(finalBmi >= 18.5 && finalBmi <= 25)
        {
            categoryResult.text = "Normal"
        }
        else if(finalBmi >= 25 && finalBmi <= 30)
        {
            categoryResult.text = "Overweight"
        }
        else if(finalBmi >= 30 && finalBmi <= 35)
        {
            categoryResult.text = "Obese Class I"
        }
        else if(finalBmi >= 35 && finalBmi <= 40)
        {
            categoryResult.text = "Obese Class II"
        }
        else if(finalBmi > 40)
        {
            categoryResult.text = "Obese Class III"
        }
        else
        {
            categoryResult.text = "Invalid input"
        }
        
    }
    
    
    // save personal data by done action in db
    @IBAction func done(_ sender: UIButton) {
        let user = User(context: self.context)
        user.name = Name.text ?? ""
        user.age = Int32(Age.text ?? "0") ?? 0
        user.gender = Gender.text ?? ""
        user.weight = Double(Weight.text ?? "0.0") ?? 0.0
        user.height = Double(Height.text ?? "0.0") ?? 0.0
        do {
            try context.save()
        } catch {
            print(error)
        }
        let controller = storyboard?.instantiateViewController(withIdentifier: "BMITracker") as! BMITrackerVC
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

