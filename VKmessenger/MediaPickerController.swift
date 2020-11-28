//
//  MediaPickerController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 03.10.2020.
//

import UIKit
import PhotosUI
import Photos
import AVKit
import AVFoundation

extension ChatViewController: UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @objc func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Фото или Видео", style: .default, handler: { _ in
            var configuration = PHPickerConfiguration()
            configuration.filter = PHPickerFilter.any(of: [.images, .videos])
            configuration.selectionLimit = 10
            configuration.preferredAssetRepresentationMode = .current
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Геопозиция", style: .default, handler: { _ in
            let picker = LocationPickerViewController()
            picker.navigationController?.navigationBar.isHidden = false
            self.present(picker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Файл", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
//        guard let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String else {
//             return
//        }
//
//        if mediaType  == "public.image" {
//            if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
//                let item: AttachedItem = .Image(image)
//                self.attachedItems.append(item)
//                inputBar.itemsCollectionView?.reloadSections([0])
//            }
//        } else if mediaType == "public.movie" {
//            print("here")
//            if let videoURL = info[.mediaURL] as? URL {
////                DispatchQueue.main.async {
////                    print("here")
////                    let url = URL(fileURLWithPath: videoURL)
//                    guard let thumbnail = self.generateThumbnail(path: videoURL) else { return }
//                    let video = Media(url: videoURL, thumbnail: thumbnail)
//                    let item: AttachedItem = .Video(video)
//                    self.attachedItems.append(item)
//                    self.inputBar.itemsCollectionView?.reloadSections([0])
////                }
//            }
//        }
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        
        for itemProvider in itemProviders {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        if let image = image as? UIImage {
                            let item: AttachedItem = .Image(image)
                            self.attachedItems.append(item)
                            self.inputBar.itemsCollectionView?.reloadSections([0])
                        } else {
                            self.presentErrorAlert("Couldn't load image with error: \(error?.localizedDescription ?? "unknown error")")
                        }
                    }
                }
            } else if itemProvider.registeredTypeIdentifiers.contains(AVFileType.mov.rawValue) {
                itemProvider.loadFileRepresentation(forTypeIdentifier: AVFileType.mov.rawValue) { (fileURL, error) in
                    if let error = error {
                            print(error)
                            return
                    }
                    guard let videoURL = fileURL else { return }
                    DispatchQueue.main.sync {
                        guard let thumbnail = self.generateThumbnail(path: videoURL) else { return }
                        let player = AVPlayer(url: videoURL)
                        let video = Media(url: videoURL, thumbnail: thumbnail, duration: player.currentItem!.asset.duration)
                        let item: AttachedItem = .Video(video)
                        self.attachedItems.append(item)
                        self.inputBar.itemsCollectionView?.reloadSections([0])
                    }
                }
            } else {
                presentErrorAlert("Unsupported item provider: \(itemProvider)")
            }
        }
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            presentErrorAlert("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func presentErrorAlert(_ message: String?) {
        let alert = UIAlertController(title: "Произошла ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Oк", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

