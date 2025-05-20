//
//  ViewController.swift
//  TodoApp
//
//  Created by Esra Arı on 15.05.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskList : [TaskEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchTasks()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addNewTask))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
    }
    @objc func addNewTask(){
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let task = taskList[indexPath.row]
        content.text = task.text
        cell.contentConfiguration = content
        var color: UIColor
           
        switch task.priority {
           case 2:
               color = UIColor.systemRed.withAlphaComponent(0.1)
               content.image = UIImage(systemName: "circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
           case 1:
               color = UIColor.systemOrange.withAlphaComponent(0.1)
               content.image = UIImage(systemName: "circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
           default:
               color = UIColor.systemGreen.withAlphaComponent(0.1)
               content.image = UIImage(systemName: "circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
           }
           cell.backgroundColor = color
           cell.contentConfiguration = content
        if task.isCompleted {
            content.textProperties.color = .gray
            content.secondaryTextProperties.color = .lightGray
            cell.backgroundColor = UIColor.systemGray6
        }

        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = taskList[indexPath.row]
        
        //  TAMAMLANDI Aksiyonu
        let completeAction = UIContextualAction(style: .normal, title: task.isCompleted ? "Geri Al" : "Tamamlandı") { (action, view, completionHandler) in
            
            // Durumu tersine çevir
            task.isCompleted = !task.isCompleted
            
            // Kaydet
            self.saveContext()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        completeAction.backgroundColor = task.isCompleted ? .gray : .systemGreen
        
        // SİLME Aksiyonu
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (action, view, completionHandler) in
            self.deleteTask(task)
            completionHandler(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
        return config
    }
    func saveContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Kaydedilemedi: \(error)")
        }
    }
    func deleteTask(_ task: TaskEntity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(task)
        saveContext()
        fetchTasks()
    }



    
    
    func fetchTasks(){
        taskList.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count>0 {
                for result in results as! [NSManagedObject] {
                    taskList.append(result as! TaskEntity)
                }
                tableView.reloadData()
            }
        }catch{
            print("veri çekilemedi!")
        }
    }

}

