//
//  CitiesTableViewController.swift
//  weather
//
//  Created by Vladimir Psyukalov on 19.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import UIKit

class CitiesTableViewController: AccordionTableViewController, UpdaterProtocol {
    
    private var cities: [[String : Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("cities_title", comment: "")
        let nib = UINib.init(nibName: CityTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier)
        let updater = Updater.shared
        updater.observers.append(self)
        if let data = updater.data {
            cities = data
            tableView.reloadData()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    func didUpdate(data: [[String : Any]]?) {
        cities = data
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrappedCities = cities {
            return unwrappedCities.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? CityTableViewCell {
            if let unwrappedCities = cities {
                let city = unwrappedCities[indexPath.row]
                if let name = city[keyPath: "name"] as? String {
                    cell.cityLabel.text = name
                }
                if let temp = city[keyPath: "main.temp"] as? Double {
                    cell.temperatureLabel.text = temp.fullString()
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 74.0 : 38.0
    }
    
}
