//
//  PlaceController.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 28.06.22.
//

import UIKit
import MapKit
import CoreLocation

class PlaceController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    
    var identifier = "PlaceCell"
    var places = [PlaceModel]()
    var loggedUser: Credentials?
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        map.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        manager.stopUpdatingLocation()
        
        //            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        //
        //            let region = MKCoordinateRegion(center: coordinate, span: span)
        //                                        map.setRegion(region, animated: true)
        //            map.setRegion(region, animated: true)
        
        var pins = [MKAnnotation]()
        for place in places {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            pin.title = place.name
            pins.append(pin)
            print(place.longitude)
        }
        map.showAnnotations(pins, animated: true)
//        map.addAnnotations(pins)
    }
    

    
    @IBAction func segmentTapped(_ sender: Any) {
        switch segment.selectedSegmentIndex{
        case 0:
            table.isHidden = false
            map.isHidden = true
        case 1:
            table.isHidden = true
            map.isHidden = false
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PlaceCell
        cell.img.image = UIImage(named: places[indexPath.row].image[0])
        cell.label.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        176
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "CityController") as! CityController
        viewCont.title = places[indexPath.row].name
        viewCont.place = places[indexPath.row]
        viewCont.loggedUser = loggedUser
        
        navigationController?.show(viewCont, sender: nil)
    }
    
}
