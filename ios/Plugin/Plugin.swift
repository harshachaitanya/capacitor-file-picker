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

   

    

    func getMimeTypeFrom(_ pathExtension: String) -> String{

        switch pathExtension {

        case "mp4":

            return "video/*"

        case "jpg":

            return "image/*"

        case "png":

            return "image/*"

        default:

            return "*/*"

        }

        

    }

    

    @objc func showFilePicker(_ call: CAPPluginCall) {

        let defaults = UserDefaults()

        defaults.set(call.callbackId, forKey: "callbackId")

        

        call.save()

      

        let fileTypes = call.options["fileTypes"] as? [String] ?? []

        var types = [String]();

        for type in fileTypes{

            if(type.contains("video")){

                types.append(String(kUTTypeMovie))

                types.append(String(kUTTypeVideo))

            }

            

            if(type.contains("image")){

                types.append(String(kUTTypeImage))

            }

            

            if(!type.contains("video") && !type.contains("image")){

                types.append(String(kUTTypePDF))

                types.append(String(kUTTypeApplication))

            }

        }

        

        DispatchQueue.main.async {

            let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

            documentPicker.delegate = self

            documentPicker.allowsMultipleSelection = false

            self.bridge.viewController.present(documentPicker, animated: false, completion: nil)

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

        call.resolve(ret)

    }

}
            if(type.contains("image")){
