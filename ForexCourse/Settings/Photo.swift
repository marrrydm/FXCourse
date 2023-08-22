import MobileCoreServices
import Photos
import UIKit

class CameraProvider: NSObject {

    enum PhotoLibraryTypes {
        case photoLibrary, savedPhotosAlbum
        var casted: UIImagePickerController.SourceType {
            switch self {
            case .photoLibrary: return UIImagePickerController.SourceType.photoLibrary
            case .savedPhotosAlbum: return UIImagePickerController.SourceType.savedPhotosAlbum
            }
        }
    }

    public typealias SourceType = UIImagePickerController.SourceType
    public typealias ImagePicker = UIImagePickerController
    public typealias Delegate = UINavigationControllerDelegate & UIImagePickerControllerDelegate

    private let delegate: Delegate

    init(delegate: Delegate) {
        self.delegate = delegate
    }

    // MARK: - Public
    public func getImagePicker(source: PhotoLibraryTypes,
                               canEditPhotos: Bool = true,
                               onlyImages: Bool = false) throws -> ImagePicker {

        do {
            return try getBaseController(
                source: source.casted,
                allowsEditing: canEditPhotos,
                onlyImages: onlyImages
            )
        } catch {
            throw error
        }
    }

    public func getCamera(canEditPhotos: Bool = true,
                          onlyImages: Bool = false) throws -> ImagePicker {

        do {
            let picker = try getBaseController(
                source: .camera,
                allowsEditing: canEditPhotos,
                onlyImages: onlyImages
            )

            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                picker.cameraDevice = .rear
            } else if UIImagePickerController.isCameraDeviceAvailable(.front) {
                picker.cameraDevice = .front
            } else {
                throw "No known camera type available"
            }

            picker.showsCameraControls = true
            return picker
        } catch {
            throw error
        }
    }

    // MARK: - Private
    private func getBaseController(source: SourceType,
                                   allowsEditing: Bool,
                                   onlyImages: Bool) throws -> ImagePicker {

        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            throw "Requested source not available"
        }

        let picker = UIImagePickerController()
        let imageType = kUTTypeImage as String
        picker.sourceType = source
        picker.allowsEditing = allowsEditing
        picker.delegate = self.delegate

        if onlyImages,
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: source),
           mediaTypes.contains(imageType){
            picker.mediaTypes = [imageType]
        }

        return picker
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

public extension PHPhotoLibrary {
    static func execute(controller: UIViewController,
                        onAccessHasBeenGranted: @escaping () -> Void,
                        onAccessHasBeenDenied: (() -> Void)? = nil) {

        let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
            let alert = UIAlertController(
                title: "We were unable to load your photos".localize(),
                message: "You can enable access in Privacy Settings".localize(),
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings".localize(), style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            DispatchQueue.main.async {
                controller.present(alert, animated: true)
            }
        }

        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
        case .denied, .restricted:
            onDeniedOrRestricted()
        case .authorized:
            onAccessHasBeenGranted()
        case .limited:
            onAccessHasBeenGranted()
        @unknown default:
            fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }


    }
}

private func onNotDetermined(_ onDeniedOrRestricted: @escaping (()->Void), _ onAuthorized: @escaping (()->Void)) {

    PHPhotoLibrary.requestAuthorization({ status in
        switch status {
        case .notDetermined:
            onNotDetermined(onDeniedOrRestricted, onAuthorized)
        case .denied, .restricted:
            onDeniedOrRestricted()
        case .authorized:
            onAuthorized()
        case .limited:
            onAuthorized()
        @unknown default:
            fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
    })
}
