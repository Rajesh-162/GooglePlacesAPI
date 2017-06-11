//
//  SearchViewController.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 08/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController, PlacesProtocol {
    
    @IBOutlet var searchModel: SearchViewModel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTables: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchModel.delegate = self
        searchModel.fetchPlaces()
        self.title = "Google Places"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.searchTables.tableFooterView = UIView(frame: .zero)
        self.searchBar.becomeFirstResponder()
        
        searchModel.clearHistoryResult()
        searchBar.text = ""
        searchTables.reloadData()
    }
    
    // MARK: - PlacesProtocol methods
    func didFetchedPlaces() {
        searchTables.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchDetailSegue"){
            searchModel.resultArray.removeAll()
            let searchDetailVC: ResultViewController = segue.destination as! ResultViewController
            searchDetailVC.selectedLocation = sender as! GMSAutocompletePrediction
        }
    }
}

extension SearchViewController: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Searchbar delegate & datasource
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchModel.isSearching = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchModel.isSearching = true
        
        // Get search history
        searchModel.historyArray = searchModel.getSearchHistory(forText: searchText)
        
        self.searchTables.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchModel.searchForPlace(name: searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchModel.clearHistoryResult()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchTables.reloadData()
    }
    
    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchModel.isSearching {
            return searchModel.historyArray.count
        }
        else{
            return searchModel.resultArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchModel.isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")
            cell?.textLabel?.text = searchModel.historyArray[indexPath.row]
            return cell!
        }
        else{
            let cell: PlaceTableCell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! PlaceTableCell
            cell.placeName.attributedText = searchModel.resultArray[indexPath.row].attributedPrimaryText
            if let subtitle = searchModel.resultArray[indexPath.row].attributedSecondaryText {
                cell.placeAddress.attributedText = subtitle
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchModel.isSearching {
            let historyResult = searchModel.historyArray[indexPath.row]
            self.searchBar.text = historyResult
            searchModel.clearHistoryResult()
            searchTables.reloadData()
            searchBar.resignFirstResponder()
            
            searchModel.searchForPlace(name: historyResult)
        }
        else{
            let selectedPlace = searchModel.resultArray[indexPath.row]
            
            // Save place history in database
            searchModel.save(searchText: selectedPlace.attributedPrimaryText.string)
            
            performSegue(withIdentifier: "searchDetailSegue", sender: selectedPlace)
        }
    }
}
