//
//  AvatarViewController.swift
//  trackerVS
//
//  Created by Home on 08.06.2022.
//

import UIKit

final class AvatarViewController: UIViewController, Coordinating, UINavigationControllerDelegate {
    var coordinator: Coordinator?    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.contentMode = .scaleToFill
        avatarImageView.clipsToBounds = true
        
        avatarImageView.image = coordinator?.appService?.getUserAvatar()
    }

    @IBAction func tapGetPhotoButton(_ sender: Any) {
        configImagePicker(source: .photoLibrary)
    }
    
    func configImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension AvatarViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        avatarImageView.image = image
        
        let newUserData = UserData(avatarImage: image?.jpegData(compressionQuality: 80.0))
        coordinator?.appService?.saveUserData(newUserData)
        
        dismiss(animated: true)
    }
}
