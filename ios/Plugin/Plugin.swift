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

                types.removeAll();
                types = ["public.text",
                                          "com.apple.iwork.pages.pages",
                                          "public.data",
                                          "kUTTypeItem",
                                          "kUTTypeContent",
                                          "kUTTypeCompositeContent",
                                          "kUTTypeData",
                                          "public.database",
                                          "public.calendar-event",
                                          "public.message",
                                          "public.presentation",
                                          "public.contact",
                                          "public.archive",
                                          "public.disk-image",
                                          "public.plain-text",
                                          "public.utf8-plain-text",
                                          "public.utf16-external-plain-​text",
                                          "public.utf16-plain-text",
                                          "com.apple.traditional-mac-​plain-text",
                                          "public.rtf",
                                          "com.apple.ink.inktext",
                                          "public.html",
                                          "public.xml",
                                          "public.source-code",
                                          "public.c-source",
                                          "public.objective-c-source",
                                          "public.c-plus-plus-source",
                                          "public.objective-c-plus-​plus-source",
                                          "public.c-header",
                                          "public.c-plus-plus-header",
                                          "com.sun.java-source",
                                          "public.script",
                                          "public.assembly-source",
                                          "com.apple.rez-source",
                                          "public.mig-source",
                                          "com.apple.symbol-export",
                                          "com.netscape.javascript-​source",
                                          "public.shell-script",
                                          "public.csh-script",
                                          "public.perl-script",
                                          "public.python-script",
                                          "public.ruby-script",
                                          "public.php-script",
                                          "com.sun.java-web-start",
                                          "com.apple.applescript.text",
                                          "com.apple.applescript.​script",
                                          "public.object-code",
                                          "com.apple.mach-o-binary",
                                          "com.apple.pef-binary",
                                          "com.microsoft.windows-​executable",
                                          "com.microsoft.windows-​dynamic-link-library",
                                          "com.sun.java-class",
                                          "com.sun.java-archive",
                                          "com.apple.quartz-​composer-composition",
                                          "org.gnu.gnu-tar-archive",
                                          "public.tar-archive",
                                          "org.gnu.gnu-zip-archive",
                                          "org.gnu.gnu-zip-tar-archive",
                                          "com.apple.binhex-archive",
                                          "com.apple.macbinary-​archive",
                                          "public.url",
                                          "public.file-url",
                                          "public.url-name",
                                          "public.vcard",
                                          "public.image",
                                          "public.fax",
                                          "public.jpeg",
                                          "public.jpeg-2000",
                                          "public.tiff",
                                          "public.camera-raw-image",
                                          "com.apple.pict",
                                          "com.apple.macpaint-image",
                                          "public.png",
                                          "public.xbitmap-image",
                                          "com.apple.quicktime-image",
                                          "com.apple.icns",
                                          "com.apple.txn.text-​multimedia-data",
                                          "public.audiovisual-​content",
                                          "public.movie",
                                          "public.video",
                                          "com.apple.quicktime-movie",
                                          "public.avi",
                                          "public.mpeg",
                                          "public.mpeg-4",
                                          "public.3gpp",
                                          "public.3gpp2",
                                          "public.audio",
                                          "public.mp3",
                                          "public.mpeg-4-audio",
                                          "com.apple.protected-​mpeg-4-audio",
                                          "public.ulaw-audio",
                                          "public.aifc-audio",
                                          "public.aiff-audio",
                                          "com.apple.coreaudio-​format",
                                          "public.directory",
                                          "public.folder",
                                          "public.volume",
                                          "com.apple.package",
                                          "com.apple.bundle",
                                          "public.executable",
                                          "com.apple.application",
                                          "com.apple.application-​bundle",
                                          "com.apple.application-file",
                                          "com.apple.deprecated-​application-file",
                                          "com.apple.plugin",
                                          "com.apple.metadata-​importer",
                                          "com.apple.dashboard-​widget",
                                          "public.cpio-archive",
                                          "com.pkware.zip-archive",
                                          "com.apple.webarchive",
                                          "com.apple.framework",
                                          "com.apple.rtfd",
                                          "com.apple.flat-rtfd",
                                          "com.apple.resolvable",
                                          "public.symlink",
                                          "com.apple.mount-point",
                                          "com.apple.alias-record",
                                          "com.apple.alias-file",
                                          "public.font",
                                          "public.truetype-font",
                                          "com.adobe.postscript-font",
                                          "com.apple.truetype-​datafork-suitcase-font",
                                          "public.opentype-font",
                                          "public.truetype-ttf-font",
                                          "public.truetype-collection-​font",
                                          "com.apple.font-suitcase",
                                          "com.adobe.postscript-lwfn​-font",
                                          "com.adobe.postscript-pfb-​font",
                                          "com.adobe.postscript.pfa-​font",
                                          "com.apple.colorsync-profile",
                                          "public.filename-extension",
                                          "public.mime-type",
                                          "com.apple.ostype",
                                          "com.apple.nspboard-type",
                                          "com.adobe.pdf",
                                          "com.adobe.postscript",
                                          "com.adobe.encapsulated-​postscript",
                                          "com.adobe.photoshop-​image",
                                          "com.adobe.illustrator.ai-​image",
                                          "com.compuserve.gif",
                                          "com.microsoft.bmp",
                                          "com.microsoft.ico",
                                          "com.microsoft.word.doc",
                                          "com.microsoft.excel.xls",
                                          "com.microsoft.powerpoint.​ppt",
                                          "com.microsoft.waveform-​audio",
                                          "com.microsoft.advanced-​systems-format",
                                          "com.microsoft.windows-​media-wm",
                                          "com.microsoft.windows-​media-wmv",
                                          "com.microsoft.windows-​media-wmp",
                                          "com.microsoft.windows-​media-wma",
                                          "com.microsoft.advanced-​stream-redirector",
                                          "com.microsoft.windows-​media-wmx",
                                          "com.microsoft.windows-​media-wvx",
                                          "com.microsoft.windows-​media-wax",
                                          "com.apple.keynote.key",
                                          "com.apple.keynote.kth",
                                          "com.truevision.tga-image",
                                          "com.sgi.sgi-image",
                                          "com.ilm.openexr-image",
                                          "com.kodak.flashpix.image",
                                          "com.j2.jfx-fax",
                                          "com.js.efx-fax",
                                          "com.digidesign.sd2-audio",
                                          "com.real.realmedia",
                                          "com.real.realaudio",
                                          "com.real.smil",
                                          "com.allume.stuffit-archive",
                                          "org.openxmlformats.wordprocessingml.document",
                                          "com.microsoft.powerpoint.​ppt",
                                          "org.openxmlformats.presentationml.presentation",
                                          "com.microsoft.excel.xls",
                                          "org.openxmlformats.spreadsheetml.sheet",
                                         
                    
                  ]

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
           
