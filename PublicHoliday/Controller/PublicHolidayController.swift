//
//  PublicHolidayController.swift
//  PublicHoliday
//
//  Created by Maik Nestler on 23.04.21.
//

import UIKit

let reuseIdentifier = "PublicCell"

class PublicHolidayController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Properties
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var holidayList = [HolidayDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.holidayList.count) Holidays found"
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureSearchBar()
        configureTableView()
    }
    
    //MARK: - Functions
    func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "Public Holiday"
        navigationController?.navigationBar.backgroundColor = .white 
    }
    
    func configureSearchBar() {
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Enter your ISO Country Code"
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }
        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        holidayRequest.getHolidays { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holidays):
                self?.holidayList = holidays
            
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PublicCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
    }
    
    //MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidayList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PublicCell
        let holiday = holidayList[indexPath.row]
        
        cell.titleLabel.text = holiday.name
        cell.subtitleLabel.text = holiday.date.iso
        return cell
    }
    
}




