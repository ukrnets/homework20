//
//  GalleryViewController.swift
//  Homework20
//
//  Created by Darya Grabowskaya on 2.11.22.
//

import UIKit

class GalleryViewController: UIViewController {
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - IBActions
    @IBAction func buttonAddPhotos(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraSourceType = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showPicker(withSourceType: .camera)
        }
        let librarySourceType = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showPicker(withSourceType: .photoLibrary)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraSourceType)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(librarySourceType)
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    private func setPhotos(_ image: UIImage, withName name: String? = nil) {
        
        imageView.image = image
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else { return }
        deletePhotos()
        try? data.write(to: fileURL)
        UserDefaults.standard.set(fileName, forKey: "imageView")
    }
    
    private func loadPhotos() {
        guard let fileName = UserDefaults.standard.string(forKey: "imageView") else { return }
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        
        guard let savedData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: savedData) else { return }
        imageView.image = image
    }
    
    private func deletePhotos() {
        guard let fileName = UserDefaults.standard.string(forKey: "imageView") else { return }
        UserDefaults.standard.removeObject(forKey: "imageView")
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func showPicker(withSourceType sourceType: UIImagePickerController.SourceType) {
        
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = sourceType
        present(pickerController, animated: true)
    }
}

// MARK: - Extensions
extension GalleryViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentedViewController?.dismiss(animated: true)
        let alert = UIAlertController(title: "Are you sure?", message: "You didn't pick any photos", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var name: String?
        if let imageName = info[.imageURL] as? URL {
            name = imageName.lastPathComponent
        }
        setPhotos(image, withName: name)
        self.presentedViewController?.dismiss(animated: true)
    }
}

extension GalleryViewController: UINavigationControllerDelegate {
    
}
