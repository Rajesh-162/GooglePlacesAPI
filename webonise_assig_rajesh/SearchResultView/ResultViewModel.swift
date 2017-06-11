//
//  ResultViewModel.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 11/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit

class ResultViewModel: NSObject {

    let ZoomLevel = 1609.344
    var delegate: PlaceDetailsProtocol?
    
    // Get details to map pin
    func getAnnotation(fromLocation location: GMSPlace) -> (annotaion: MKAnnotation, region: MKCoordinateRegion){
        
        // Annotation
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = location.name
        annotation.subtitle = location.formattedAddress
        
        // Region
        let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 0.5*ZoomLevel, 0.5*ZoomLevel)
        
        return (annotation, viewRegion)
    }
    
    // Get photo image and assign to caller
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, thumbnil: AnyObject) {
        
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                
                if let button: UIButton = thumbnil as? UIButton{
                    button.setImage(photo, for: .normal)
                }
                else if let image: UIImageView = thumbnil as? UIImageView{
                    image.image = photo;
                }
            }
        })
    }
    
    // Get thumbnil for gallery
    func getThumbnil(withTag tag: Int, xAxis: Double) -> (_ photo: GMSPlacePhotoMetadata) -> UIButton{
        var lxAxis = 5.0
        var ltag = 0
        
        func configureThumbnil(_ photo: GMSPlacePhotoMetadata) -> UIButton {
            let btnPhoto = UIButton(frame: CGRect(x: lxAxis, y: 0, width: xAxis, height: xAxis))
            btnPhoto.layer.cornerRadius = 8
            btnPhoto.layer.masksToBounds = true
            btnPhoto.layer.borderColor = UIColor.red.cgColor
            btnPhoto.layer.borderWidth = 2
            btnPhoto.tag = ltag
            
            loadImageForMetadata(photoMetadata: photo, thumbnil: btnPhoto)
            lxAxis += xAxis + 5
            ltag += tag
            
            return btnPhoto
        }
        return configureThumbnil
    }
    
    // Check place details
    func isValidPlace(placeId: String){
        let placesClient = GMSPlacesClient()        
        var lplace: GMSPlace?
        placesClient.lookUpPlaceID(placeId, callback: { (place, error) -> Void in
            lplace = place
            
            if let activeDelegate = self.delegate{
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    activeDelegate.placeDetails(isValid: false, place: lplace)
                    return
                }
                
                guard place != nil else {
                    print("No place details for \(placeId)")
                    activeDelegate.placeDetails(isValid: false, place: lplace)
                    return
                }
                activeDelegate.placeDetails(isValid: true, place: lplace)
            }
        })
    }
    
    // Get place photos
    func getPhotosForPlace(withId id: String){
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: id) { (photos, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let activeDelegate = self.delegate{
                    activeDelegate.placePhotos(photos!)
                }
            }
        }
    }
}
