//
//  WeatherViewController.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherPrediction: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var weatherTable: UITableView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton = true
        weatherTable.tableFooterView = UIView()
    }
    
    //Do and undo favourites
    @IBAction func favBtnAction(_ sender: Any) {
        self.viewModel.addTofavourite{success in
            if success {
                DispatchQueue.main.async {
                    self.updateFavouriteIconState()
                }
            }
        }
    }

    @IBAction func showFavouritesCont(_ sender: Any) {
        let favouriteVc = FavouriteListViewController.favouritesViewController()
        favouriteVc.delegate = self
        self.navigationController?.pushViewController(favouriteVc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          retriveCityWeather(city: kDefaultCity)
     }
    
    func updateFavouriteIconState() {
        let isFavCity = self.viewModel.checkIfFavCity()
        let image = isFavCity ? UIImage(named: kFilledImage) : UIImage(named: kImage)
        self.favButton.setImage(image, for: .normal)
    }
    
    func retriveCityWeather(city: String) {
        self.viewModel.fetchWeatherDetails(city: city) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.tempLabel.text = self?.viewModel.temperature[ WeatherKeyContants.kTemp]
                    self?.weatherPrediction.text = self?.viewModel.temperature[WeatherKeyContants.kTempStatus]
                    self?.weatherDescLabel.text = self?.viewModel.temperature[WeatherKeyContants.kTempDesc]
                    self?.cityLbl.text = self?.viewModel.temperature[WeatherKeyContants.kCity]
                    self?.updateFavouriteIconState()
                    self?.weatherTable.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: kerror, message: error) { (action) in
                    }
                }
                
            }
        }
        
    }
    
}

extension WeatherViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherDetailInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kcell, for: indexPath)
        cell.textLabel?.text = viewModel.weatherDetailInfo[indexPath.row].key
        cell.detailTextLabel?.text = viewModel.weatherDetailInfo[indexPath.row].value
        return cell
    }
}


extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        retriveCityWeather(city: searchBar.text ?? "")
        searchBar.resignFirstResponder()
        searchBar.text?.removeAll()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
    }

}

extension WeatherViewController: CityNameDelegate {
    func selectedCity(withCityName: String) {
        self.retriveCityWeather(city: withCityName)
    }
}
