//
//  AlbumVC.swift
//  virtualTourist
//
//  Created by Tawfeeq on 25/12/2018.
//  Copyright © 2018 tam. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AlbumVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var pin: Pin! // pass the pin
    var page = 0  // to retrieve new collection
    var dataController:DataController! // CoreData context reference
    var fetchedResultsController: NSFetchedResultsController<Photo>!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = PhotoHelper.fetchController(pin: pin, context: dataController.context)

        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchedResultsController.delegate = self
        
        showLocation()
        getImages()
        // Do any additional setup after loading the view.
    }
    
    func getImages(){
        do{
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count  == 0{
                page = page + 1
                PhotoHelper.getImagesUrls(lat: pin.latitude, long: pin.longitude,page:page) { (urls,error) in
                    if let error = error {
                        self.collectionView.showMessage(error)
                        return
                    }
                    for url in urls{
                        PhotoHelper.add(url: url,pin:self.pin,context: self.dataController.context)
                    }
                    self.collectionView.reloadData()
                }
            }
            else{
                collectionView.reloadData()
            }
        }
        catch{
            fatalError("Error fetching: \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func newAlbumCollection(_ sender: Any) {
        print("new Collection")
        PhotoHelper.deleteAll(fetchController: fetchedResultsController, context: dataController.context)
        collectionView.reloadData()
        getImages()
    }
    
    func showLocation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        mapView.addAnnotation(annotation)
        mapView.region.center = annotation.coordinate
        let viewRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
    
    }


}


extension AlbumVC : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert,.update,.delete:
            self.collectionView.reloadData()
        default:
            return
        }
    }
}


extension AlbumVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        }
        else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
}

extension AlbumVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Return the number of items
        if (fetchedResultsController.fetchedObjects?.count  == 0) {
            collectionView.showMessage("Nothing to show :(")
        } else {
            collectionView.restore()
        }
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //TODO: Dequeue each cell, fill it with a photo, and return it
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCVC
        cell.photo = fetchedResultsController.object(at: indexPath)
        //cell.photoImage.image = photos[indexPath.row]
        if let image = cell.photo.image {
            cell.photoImage.image = UIImage(data:image)
        } else if let url = URL(string: cell.photo.url!) {
            cell.photoImage.kf.indicatorType = .activity
            cell.photoImage.kf.setImage(with: url)
        }
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //TODO: Set the columns to 2 and the rows to 2 in a rectangle area of the collection view (ususally the area visible on the secreen).
        let width = collectionView.bounds.width - 10
        return CGSize(width: width/4, height: width/4)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //TODO: Set the left and right spacing of a cell to be 2
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //TODO: Set minimumLineSpacing to 0
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        //TODO: Set minimumInteritemSpacing to 0
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotoHelper.delete(photo: fetchedResultsController.object(at: indexPath), context: dataController.context)
    }
    
}

extension UICollectionView {
    
    func showMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

