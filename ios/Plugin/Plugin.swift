import Foundation
import Capacitor
import MobileCoreServices



/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
typealias JSObject = [String:Any]
@objc(FilePicker)
public class FilePicker: CAPPlugin {
    
    private class FileTypes {
        static let PDF = "pdf"
        static let IMAGE = "image"
    }
    
    func getAllowedFileTypes(fileTypes: [String]) -> [CFString] {
        var acceptTypes: [CFString] = []
        
        for fileType in fileTypes {
            switch fileType {
            case FileTypes.PDF:
                acceptTypes.append(kUTTypePDF)
                break
            case FileTypes.IMAGE:
                acceptTypes.append(kUTTypeImage)
                break
            default:
            
                break
            }
        }
        
        if acceptTypes.count > 0 {
            return acceptTypes
        }
        
        return [kUTTypeItem]
    }
    
    func getMimeTypeFrom(_ pathExtension: String) -> String{
        switch pathExtension {
        case "pdf":
            return "application/pdf"
        case "jpg":
            return "image/jpeg"
        default:
            return "image/" + pathExtension
        }
        
    }
    
    
    func ConvertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    @objc func showFilePicker(_ call: CAPPluginCall) {
        let defaults = UserDefaults()
        defaults.set(call.callbackId, forKey: "callbackId")
        
        call.save()
        
        let fileTypes = call.options["fileTypes"] as? [String] ?? []
        
        let types = getAllowedFileTypes(fileTypes: fileTypes)
        
        
        DispatchQueue.main.async {
            let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.bridge.viewController.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    
}

extension FilePicker: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let defaults = UserDefaults()
        let id = defaults.string(forKey: "callbackId") ?? ""

        guard let call = self.bridge.getSavedCall(id) else {
            return
        }
        
        let pathExtension = urls[0].pathExtension
        
        //get file size
        var fileSizeValue: UInt64 = 0
        do {
                let fileAttribute: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: urls[0].path)

                if let fileNumberSize: NSNumber = fileAttribute[FileAttributeKey.size] as? NSNumber {
                    fileSizeValue = UInt64(truncating: fileNumberSize)
                }
            } catch {
                print(error.localizedDescription)
            }
       
        var ret = JSObject()
        
        ret["uri"] = urls[0].absoluteString
        ret["name"] = urls[0].lastPathComponent
        ret["mimeType"] = getMimeTypeFrom(pathExtension)
        ret["extension"] = pathExtension
        ret["size"] = fileSizeValue
        if getMimeTypeFrom(pathExtension).contains("image")  {
                let image = UIImage(contentsOfFile: urls[0].path)
                let imageData: Data? = image!.jpegData(compressionQuality: 0.4)
                let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                ret["base64String"] = imageStr
        }else{
            ret["base64String"] = ""
        }
        call.resolve(ret)
    }
}
