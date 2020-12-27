//
//  ChatViewControllerPickerExtension.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 03.10.2020.
//

import UIKit
import Foundation
import PhotosUI
import Photos
import AVKit
import AVFoundation
import UniformTypeIdentifiers

extension ChatViewController {
    @objc func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.presentCameraPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Фото или Видео", style: .default, handler: { _ in
            self.presentMediaPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Геопозиция", style: .default, handler: { _ in
            self.presentLocationPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Файл", style: .default, handler: { _ in
            self.presentDocumentPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func presentCameraPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func presentMediaPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
        
//        var configuration = PHPickerConfiguration()
//        configuration.filter = PHPickerFilter.any(of: [.images, .videos])
//        configuration.selectionLimit = 10 - attachedItems.count
//        configuration.preferredAssetRepresentationMode = .current
//
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        self.present(picker, animated: true)
    }
    
    func presentLocationPicker() {
        let locationPicker = LocationPickerViewController()
        locationPicker.navigationController?.navigationBar.isHidden = false
        locationPicker.delegate = self
        self.present(locationPicker, animated: true)
    }
    
    func presentDocumentPicker() {
        let types: [UTType] = [.item]
    
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    func presentErrorAlert(_ message: String?) {
        let alert = UIAlertController(title: "Произошла ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Oк", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK - UIImagePickerControllerDelegate

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String else {
             return
        }

        if mediaType  == "public.image" {
            if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                let item: AttachedItem = .Image(image: image)
                self.messagesDelegate.didSelectItemToAttach(item)
            }
        } else if mediaType == "public.movie" {
            if let videoURL = info[.mediaURL] as? URL {
                pickVideo(videoURL, error: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickVideo(_ fileURL: URL?, error: Error?) {
        if let error = error {
                print(error)
                return
        }
        guard let videoURL = fileURL else { return }
        guard let thumbnail = self.generateThumbnail(path: videoURL) else { return }
        let asset = AVAsset(url: videoURL)
        let video = Media(url: videoURL, thumbnail: thumbnail, duration: asset.duration)
        let item: AttachedItem = .Video(media: video)
        self.messagesDelegate.didSelectItemToAttach(item)
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
}

// MARK - PHPickerViewControllerDelegate
//
//extension ChatViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        dismiss(animated: true)
//
//        itemProviders = results.map(\.itemProvider)
//
//        for itemProvider in itemProviders {
//            var didLoad = false
//            if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                didLoad = true
//                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                    DispatchQueue.main.async {
//                        guard let self = self else {
//                            return
//                        }
//                        if let image = image as? UIImage {
//                            let item: AttachedItem = .Image(image: image)
//                            self.attachedItems.append(item)
//                            self.inputBar.itemsCollectionView?.reloadSections([0])
//                        } else {
//                            self.presentErrorAlert("Couldn't load image with error: \(error?.localizedDescription ?? "unknown error")")
//                        }
//                    }
//                }
//            } else {
//                let videoTypes: [UTType] = [.quickTimeMovie, .mpeg4Movie, .mpeg2Video, .video, .movie, .image]
//                for videoType in videoTypes {
//                    if itemProvider.registeredTypeIdentifiers.contains(videoType.identifier) {
//                        didLoad = true
//                        itemProvider.loadInPlaceFileRepresentation(forTypeIdentifier: videoType.identifier) { (fileURL, possible, error) in
//                            self.pickVideo(fileURL, error: error)
//                        }
//                    }
//                }
//            }
//            if !didLoad {
//                presentErrorAlert("Unsupported item provider: \(itemProvider)")
//            }
//        }
//    }
//
//
//}

// MARK - LocationPickerDelegate

extension ChatViewController: LocationPickerDelegate {
    func locationPickerDidSelectLocation(_ item: AttachedItem) {
        dismiss(animated: true, completion: nil)
        self.messagesDelegate.didSelectItemToAttach(item)
    }
}

// MARK - UIDocumentPickerDelegate

extension ChatViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            let size = fileAttributes[.size] as! Int64 
            let name = FileManager.default.displayName(atPath: url.path)
            let type = url.pathExtension
            let document = Document(url: url, name: name, type: type, size: size)
            let item: AttachedItem = .Document(document: document)
            self.messagesDelegate.didSelectItemToAttach(item)
        } catch {
            presentErrorAlert("Failed to pick docment")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

    }
}
