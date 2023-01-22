
import PhotosUI

extension FindViewController: PHPickerViewControllerDelegate {
//Galeriden fotoğraf seçimi
    var photoPicker: PHPickerViewController {
       var imagePickerController = UIImagePickerController()
        checkPermission()
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self
        return photoPicker
    }

    func checkPermission(){
        
        if  PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in () })
            
        }
        
        if  PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        }
        else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
        
        
        
    }
    
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if  PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("App  have access library")
        }else
        { print("App dont have access library")}

    }



    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false)
        
        guard let result = results.first else {
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let error = error {
                print("Photo picker error: \(error)")
                return
            }

            guard let photo = object as? UIImage else {
                fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
            }

            self.userSelectedPhoto(photo)
        }
    }
}
