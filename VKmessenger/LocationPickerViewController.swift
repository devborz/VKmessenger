//
//  LocationPickerViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 22.11.2020.
//

import UIKit
import MapKit

class LocationPickerViewController: UIViewController {
    
    let cancelButton = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(didTapCancelButton))
    
    let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
    
    let sendButton = UIButton()
    
    let topBar = UINavigationBar()
    
    let topBarDefaultItem = UINavigationItem(title: "Геопозиция")
    
    let topBarSearchItem = UINavigationItem()
    
    let searchBar = UISearchBar()

    let mapView = MKMapView()
    
    let locationManager = CLLocationManager()
    
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
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSearchButton() {
        topBar.pushItem(topBarSearchItem, animated: true)
        searchBar.becomeFirstResponder()
    }
    
    @objc func didTapSendButton() {
        
    }
    
    @objc func didTapSearchBarCancelButton() {
        
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
