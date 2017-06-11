//
//  SearchViewModel.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 11/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewModel: NSObject, GMSAutocompleteFetcherDelegate {

    var isSearching = true
    var fetcher: GMSAutocompleteFetcher?
    var resultArray = [GMSAutocompletePrediction]()
    var historyArray = [String]()
    
    @IBOutlet weak var db: DBHelper!
    var delegate: PlacesProtocol?
    
    func fetchPlaces(){
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: nil)
        fetcher?.delegate = self
    }
    
    // Save user search
    func save(searchText: String){
        _ = db.save(searchText: searchText)
    }
    
    // Get user search list
    func getSearchHistory(forText text: String) -> [String]{
         return db.getSearchHistory(forText: text)
    }
    
    func searchForPlace(name: String){
        isSearching = false
        
        // Search place with user input
        fetcher?.sourceTextHasChanged(name)
    }
    
    func clearHistoryResult(){
        isSearching = false
        historyArray.removeAll()        
    }

    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        resultArray = predictions
        if let activeDelegate = delegate{
            activeDelegate.didFetchedPlaces()
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}
