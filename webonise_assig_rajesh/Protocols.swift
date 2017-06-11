//
//  Protocols.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 11/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//
import GooglePlaces

protocol PlacesProtocol {
    
    func didFetchedPlaces()
}

protocol PlaceDetailsProtocol {
    
    func placeDetails(isValid: Bool, place: GMSPlace?)
    
    func placePhotos(_ photos: GMSPlacePhotoMetadataList)
}

