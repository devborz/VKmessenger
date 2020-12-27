//
//  ImageViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 01.12.2020.
//

import UIKit
import AVKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    
    let scrollView = UIScrollView()
    
    var imageView: UIImageView!
    
    var imageViewHeight: CGFloat = 0
    
    var imageViewWidth: CGFloat = 0
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.alpha = 0
        toolBar.tintColor = .white
        toolBar.barTintColor = .black
        toolBar.isTranslucent = true
        
        return toolBar
    }()
    
    let shareItem: UIBarButtonItem = {
        let shareItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right"), style: .plain, target: self, action: #selector(didPressShareItem))
        return shareItem
    }()
    
    let saveItem: UIBarButtonItem  = {
        let saveItem = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line.alt"), style: .plain, target: self, action: #selector(didPressSaveItem))
        return saveItem
    }()
    
    var menuHidden = true {
        didSet {
            if menuHidden != oldValue {
                UIView.animate(withDuration: 0.4) { [self] in
                    navigationController?.setNeedsStatusBarAppearanceUpdate()
                    navigationController?.navigationBar.alpha = menuHidden ? 0 : 1
                    toolBar.alpha = menuHidden ? 0 : 1
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return menuHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.alpha = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = .white
        view.backgroundColor = .black
        setupImageView()
        setupToolbar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupImageView() {
        imageView = UIImageView(image: image)
        
        view.addSubview(scrollView)
        
        scrollView.frame = view.frame
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        scrollView.contentSize = imageView.bounds.size
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(gesture)
        
        setZoomScale()
        scrollView.zoomScale = scrollView.minimumZoomScale
        centerImageView()
    }
    
    func setZoomScale() {
        let imageSize = imageView.bounds.size
        let heightScale =  scrollView.bounds.size.height / imageSize.height
        let widthScale =  scrollView.bounds.size.width / imageSize.width
        let minScale = min(heightScale, widthScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 4
    }
    
    func centerImageView() {
        
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * CGFloat(0.5), CGFloat(0.0))
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    func setupToolbar() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        toolBar.items = [shareItem, .flexibleSpace(), saveItem]
        
        toolBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func didTapScrollView() {
        menuHidden = !menuHidden
    }
    
    @objc func didPressShareItem() {
        
    }
    
    @objc func didPressSaveItem() {
        
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
        
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuHidden = true
    }
}
