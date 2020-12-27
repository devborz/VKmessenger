//
//  LocationPickerViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 22.11.2020.
//

import UIKit
import MapKit

class LocationPickerViewController: UIViewController {
    
    var delegate: LocationPickerDelegate?
    
    let cancelButton = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(didTapCancelButton))
    
    let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didPressSearchButton))
    
    let sendButton = UIButton()
    
    let topBar = UINavigationBar()
    
    let topBarDefaultItem = UINavigationItem(title: "Геопозиция")
    
    let topBarSearchItem = UINavigationItem()
    
    let searchBar = UISearchBar()

    let mapView = MKMapView()
    
    let locationManager = CLLocationManager()
    
    var annotation: MKPointAnnotation? {
        didSet {
            if annotation != nil {
                sendButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTopBar()
        setupSearchBar()
        setupMapView()
        setupSendButton()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.setCenter((locationManager.location?.coordinate)!, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: (locationManager.location?.coordinate)!, latitudinalMeters: CLLocationDistance(800), longitudinalMeters: 800), animated: true)
        
        checkPermissions()
    }
    
    func checkPermissions() {
        if !CLLocationManager.locationServicesEnabled() {
            let alertController = UIAlertController(title: "Ваша геопозиция недосупна", message: "Вы можете разрешить приложению получать данные о вашей геопозиции в настройках" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setupTopBar() {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        
        topBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        topBar.backgroundColor = .systemBackground
        
        topBar.pushItem(topBarDefaultItem, animated: false)
        
        topBarDefaultItem.leftItemsSupplementBackButton = true
        
        topBarDefaultItem.rightBarButtonItem = searchButton
        topBarDefaultItem.leftBarButtonItem = cancelButton
        
        cancelButton.title = "Отмена"
    }
    
    func setupSearchBar() {
        topBarSearchItem.titleView = searchBar
        topBarSearchItem.hidesBackButton = true
        
        searchBar.placeholder = "Поиск"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отменить", for: .normal)
        }
    }
    
    func setupMapView() {
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapView))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        sendButton.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.backgroundColor = .systemBackground
        
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.setTitleColor(.systemBlue, for: .normal)
        sendButton.setTitleColor(.systemGray, for: .disabled)
        sendButton.isEnabled = false
        
        sendButton.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didPressSearchButton() {
        topBar.pushItem(topBarSearchItem, animated: true)
        searchBar.becomeFirstResponder()
    }
    
    @objc func didPressSendButton() {
        guard let coordinate = annotation?.coordinate else { return }
        let item: AttachedItem = .Location(coordinate: coordinate)
        delegate?.locationPickerDidSelectLocation(item)
    }
    
    @objc func didPressSearchBarCancelButton() {
        
    }
    
    @objc func didTapMapView(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: mapView)
        let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
        addAnnotation(location: locationOnMap)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        if let lastAnnotation = self.annotation {
            mapView.removeAnnotation(lastAnnotation)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.annotation = annotation
        mapView.addAnnotation(annotation)
    }
}

extension LocationPickerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        topBar.popItem(animated: true)
    }
}

extension LocationPickerViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
}

protocol LocationPickerDelegate {
    func locationPickerDidSelectLocation(_ item: AttachedItem)
}
