//
//  AttachedItemInMessageCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.11.2020.
//

import UIKit
import MapKit

class AttachedItemInMessageCell: UICollectionViewCell {
    
    var attachedItem: AttachedItem?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        attachedItem = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    func setup(_ attachedItem: AttachedItem) {
        self.attachedItem  = attachedItem
        switch attachedItem  {
        case .Image(let image): setupImageItem(image)
        case .Video(let media): setupVideoItem(media)
        case .Document(let document): setupDocumentItem(document)
        case .Location(let coordinate): setupLocationItem(coordinate)
        case .Message(message: let _): break
        }
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setupImageItem(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
    
    func setupVideoItem(_ media: Media) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imageView.image = media.thumbnail
        imageView.contentMode = .scaleAspectFill
        
        let time: Int = Int(media.duration.seconds)
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var durationStamp = ""
        if hours > 0 {
            durationStamp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            durationStamp = String(format:"%02i:%02i", minutes, seconds)
        }
        
        let durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(durationLabel)
        durationLabel.text = durationStamp
        
        durationLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -5).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5).isActive = true
        durationLabel.widthAnchor.constraint(equalToConstant: NSAttributedString(string: durationStamp, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11, weight: .semibold)]).size().width + 8).isActive = true
        
        durationLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        durationLabel.textColor = .white
        durationLabel.textAlignment = .center
        durationLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
        durationLabel.layer.cornerRadius = 5
        durationLabel.clipsToBounds = true
    }
    
    func setupDocumentItem(_ document: Document) {
        self.backgroundColor = .systemGray
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageView.image = UIImage(systemName: "doc.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        
        nameLabel.textColor = .white
        nameLabel.text = document.name
        nameLabel.font = .systemFont(ofSize: 12)
        
        let sizeLabel = UILabel()
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(sizeLabel)
        sizeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        sizeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        sizeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true

        sizeLabel.text = ByteCountFormatter.string(fromByteCount: document.size, countStyle: .memory)
        sizeLabel.font = .systemFont(ofSize: 12)
    }
    
    func setupLocationItem(_ coordinate: CLLocationCoordinate2D) {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        mapView.setCenter(coordinate, animated: false)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: CLLocationDistance(500), longitudinalMeters: 500), animated: false)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray5.cgColor
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

