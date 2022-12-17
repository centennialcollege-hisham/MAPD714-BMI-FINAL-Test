//
//  BMITrackerVC.swift
//  BMI_Calculator
//
//  Created by Hisham Abu Sanimeh on 16/12/2022.
//

import UIKit
import CoreData

class BMITrackerVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    public var Nweight: Float = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newWeight: UITextField!
    @IBOutlet weak var newDate: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //data array for tableview
    var items:[BMIItem]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(BMIcellTableViewCell.nib(), forCellReuseIdentifier: "BMIcellTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //fetch core data content
        fetchBMIitems()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items!.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "BMIcellTableViewCell") as! BMIcellTableViewCell
        
        let recordWeight: Float = Float((items![indexPath.row].value(forKey: "nWeight") as? NSNumber)!)
        
        let recordBmi: Float = Float((items![indexPath.row].value(forKey: "nBmi") as? NSNumber)!)
        
        customCell.config(BMI: recordBmi, Weight: recordWeight, date: Date())
        
        return customCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = items {
            updateItem(item: items[indexPath.row])
        }
    }
    
    private func updateItem(item: BMIItem) {
        let alert = UIAlertController(title: "Update Wight", message: "Please input new Wight", preferredStyle: UIAlertController.Style.alert )
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                do {
                    let Nweight = Float(textField.text ?? "0.0") ?? 0.0
                    item.nWeight = Nweight
                    let user = try self.context.fetch(NSFetchRequest<User>(entityName: "User")).last
                    let height = user?.height ?? 1.8
                    let finalBmi = Float(Nweight)/Float(height*height)
                    item.nBmi = finalBmi
                    try self.context.save()
                    DispatchQueue.main.async {
                        self.fetchBMIitems()
                    }
                } catch {
                    
                }
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your new Wight"
            textField.text = "\(item.nWeight)"
        }
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)

        self.present(alert, animated:true, completion: nil)
    }
    
    func fetchBMIitems()
    {
        do{
            self.items = try context.fetch(BMIItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            tableView.reloadData()
        }
        catch{
            
        }
        
    }
    
    //update button function on press
    @IBAction func update(_ sender: UIButton)
    {
        do {
        let user = try context.fetch(NSFetchRequest<User>(entityName: "User")).last
        Nweight = (newWeight.text! as NSString).floatValue
        let addBmi = BMIItem(context: self.context)
        let height = user?.height ?? 1.8
        let finalBmi = Float(Nweight)/Float(height*height)
        
        addBmi.nWeight = Nweight
        addBmi.nBmi = finalBmi
        items?.append(addBmi)
        try self.context.save()
        }
        catch{
                    
        }
                
        self.fetchBMIitems()
                
    }
    
    //swipe delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete"){(action, view, completionHandler)in
            let itemremove = self.items![indexPath.row]
            self.context.delete(itemremove)
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchBMIitems()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
