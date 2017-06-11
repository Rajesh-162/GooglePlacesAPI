//
//  ResultViewController.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 08/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit

class ResultViewController: UIViewController, PlaceDetailsProtocol {

    @IBOutlet var resultModel: ResultViewModel!
    @IBOutlet weak var mapObject: MKMapView!
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var galleryView: UIScrollView!
    @IBOutlet weak var placeAddress: UILabel!
    
    var selectedLocation: GMSAutocompletePrediction!
    override func viewDidLoad() {
        super.viewDidLoad()

        resultModel.delegate = self
        
        self.title = selectedLocation.attributedPrimaryText.string
        showLocation(withPlaceId: selectedLocation.placeID!)
        if let address = selectedLocation.attributedSecondaryText{
            self.placeAddress.text = address.string
        }
    }
    
    func showLocation(withPlaceId placeId: String){
        resultModel.isValidPlace(placeId: placeId)
    }
    
    func showMap(location: GMSPlace){
        let mapData = resultModel.getAnnotation(fromLocation: location)
        self.mapObject.addAnnotation(mapData.annotaion)
        self.mapObject.region = mapData.region
    }
    
    func loadPlacePhotosWith(id: String) {
        resultModel.getPhotosForPlace(withId: id)
    }
    
    func placePhotos(_ photos: GMSPlacePhotoMetadataList){
        let results = photos.results
        if results.count > 0{
            let thumbnil = self.resultModel.getThumbnil(withTag: 1, xAxis: 60.0)
            
            // adjust scroll content
            if results.count > 6 {
                self.galleryView.contentSize = CGSize(width: (self.galleryView.frame.size.width/4)*CGFloat(results.count), height: 0)
            }
            
            // add thubnil on gallery view
            for photo in results{
                let placeThumbnil = thumbnil(photo)
                if placeThumbnil.tag == 0 {
                    self.resultModel.loadImageForMetadata(photoMetadata: photo, thumbnil: self.placePhoto)
                }
                
                placeThumbnil.addTarget(self, action: #selector(ResultViewController.selectThumbnil(_:)), for: .touchUpInside)
                self.galleryView.addSubview(placeThumbnil)
            }
        }
    }
    
    // MARK: - PlaceDetailsProtocol methods
    func placeDetails(isValid: Bool, place: GMSPlace?){
        if isValid{
            // Valid
            self.loadPlacePhotosWith(id: place!.placeID)
            self.showMap(location: place!)
        }
        else{
            // Invalid
            print ("Invalid place")
        }

    }
    
    // Thumbnil action
    func selectThumbnil(_ sender: UIButton){
        self.placePhoto.image = sender.imageView?.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
