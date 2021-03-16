//
//  FavouriteListViewController.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//

import UIKit
import CoreData

protocol CityNameDelegate : NSObject{
    func selectedCity(withCityName: String)
}

class FavouriteListViewController: UIViewController {
    
    @IBOutlet weak var favListView: UITableView!
    
    weak var delegate : CityNameDelegate?
    
    class func favouritesViewController() -> FavouriteListViewController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: String(describing: FavouriteListViewController.self)) as! FavouriteListViewController
    }
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let sort = NSSortDescriptor(key: #keyPath(City.cityName), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite List"
        favListView.tableFooterView = UIView()
        favListView.delegate = self
        favListView.dataSource = self
        
        do {
            try self.fetchedhResultController.performFetch()
            DispatchQueue.main.async {
                self.favListView.reloadData()
            }
        } catch let error  {
            self.showAlert(title: kerror, message:error.localizedDescription) { (action) in
            }
        }
       
    }
}

extension FavouriteListViewController: UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kcell, for: indexPath)
        let city = fetchedhResultController.object(at: indexPath) as? City
        cell.textLabel?.text = city?.cityName
        cell.detailTextLabel?.text = city?.weatherDetails
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = fetchedhResultController.object(at: indexPath) as? City
        delegate?.selectedCity(withCityName: selectedCity?.cityName ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}



