
import UIKit

extension FindViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Kameradan görüntü alma
    var cameraPicker: UIImagePickerController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        
        return cameraPicker
        
    }


    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        

        // Always return the original image.
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] else {
            fatalError("Picker didn't have an original image.")
        }

        guard let photo = originalImage as? UIImage else {
            fatalError("The (Camera) Image Picker's image isn't a/n \(UIImage.self) instance.")
        }
        picker.dismiss(animated: true, completion:  nil)

        userSelectedPhoto(photo)
    }
}
