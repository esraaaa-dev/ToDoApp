//
//  SecondVC.swift
//  TodoApp
//
//  Created by Esra Arı on 15.05.2025.
//

import UIKit
import CoreData

class SecondVC: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var highPriorityButton: UIButton!
    
    @IBOutlet weak var mediumPriorityButton: UIButton!
    
    @IBOutlet weak var lowPriorityButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var textView: UITextField!
    var selectedPriority : Int16 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPriorityButton()
        updatePrioritySelection()

    }
    
    func setPriorityButton(){
        highPriorityButton.tag = 2
        mediumPriorityButton.tag = 1
        lowPriorityButton.tag = 0
        updatePrioritySelection()
    }
    func updatePrioritySelection(){
        let buttons = [lowPriorityButton,mediumPriorityButton,highPriorityButton]
        for(index,button) in buttons.enumerated(){
            guard let button = button else { continue }

                    // Yuvarlak görünüm
                    button.layer.cornerRadius = button.frame.size.width / 2
                    button.clipsToBounds = true
            
            if Int16(index) == selectedPriority{
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.black.cgColor
            }
            else{
                button.layer.borderWidth = 0
            }
        }
        
    }
    @IBAction func priorityButtonTapped(_ sender: UIButton) {
        selectedPriority = Int16(sender.tag)
        updatePrioritySelection()
        
    }

    


    @IBAction func saveButtonClicked(_ sender: Any) {
  
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: context)
        newTask.setValue(textView.text, forKey: "text")
        newTask.setValue(datePicker.date, forKey: "date")
        newTask.setValue(selectedPriority, forKey: "priority")
        newTask.setValue(UUID(), forKey: "id")
        do{
            try context.save()
            print("success")
        }catch{
            print("error")
        }
        navigationController?.popViewController(animated: true)



        
        
    }
    
}
