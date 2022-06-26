//
//  Util.swift
//  JongjuAR
//
//  Created by 전민정 on 6/9/22.
//

import Foundation
import UIKit
import XmlJson


let fileManger = FileManager.default
let documentsUrl: URL = fileManger.urls(for: .documentDirectory, in: .userDomainMask).first!

// Gpx File download
func DownloadGpx(gpxPath: String, gpxFile: String) -> Bool {
    
    return DownloadFileFromUrl(urlPath: gpxPath, savedName: gpxFile)
}

func DownloadFileFromUrl(urlPath: String, savedName: String) -> Bool {
    
    var result = false
    // Create destination URL
    let destinationFileUrl = documentsUrl.appendingPathComponent("JongjuAR").appendingPathComponent(savedName)
    
    // Create URL to the source file you want to download
    let fileURL = URL(string: urlPath)
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    let request = URLRequest(url:fileURL!)
    
    // Make folder specified this app
    /*
    let folderPath = documentsUrl.appendingPathComponent("JongjuAR")
    if !FileManager.default.fileExists(atPath: folderPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true)
        } catch {
            print("Coundn't create directory for this app...")
        }
    }
    */
    
    // Download file
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode)")
            }
            
            do {
                try fileManger.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                print("Downloaded complete...")
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }
            result = true
        } else {
            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
        }
    }
    task.resume()
    
    return result
}

// Search Gpx file
func IsDownloaded(gpx: String) -> Bool {
    // 저장해놓는 폴더 경로에서 찾아보기.
    
    // Create destination URL
    let destinationFileUrl = documentsUrl.appendingPathComponent("JongjuAR").appendingPathComponent(gpx)
    
    // Make folder specified this app if folder is not exists
    // file download 전에 iddownloaded 로 확인하기 때문에 폴더 경로가 안 만들어지는 상황은 없다고 가정.
    let folderPath = documentsUrl.appendingPathComponent("JongjuAR")
    if !fileManger.fileExists(atPath: folderPath.path) {
        do {
            try fileManger.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true)
        } catch {
            print("Coundn't create directory for this app...")
        }
    }
    
    // Check exists
    if fileManger.fileExists(atPath: destinationFileUrl.path) {
        return true
    } else {
        return false
    }
}

// Parse GPX file.
func ParseGPX(gpx: String) -> Document? {
    var decoded: Document?
    // IsDownloaded
    /*
    let isDownloaded = IsDownloaded(gpx: gpx)
    
    if (!isDownloaded) {
        print("Is Not Downloaded...")
        return
    }
     */
    
    // get file

    // Create destination URL
    do {
        let destinationFileUrl = documentsUrl.appendingPathComponent("JongjuAR").appendingPathComponent(gpx)
        let dataFromPath: Data = try Data(contentsOf: destinationFileUrl)
        let data: String = String(data: dataFromPath, encoding: .utf8) ?? ""
        // print(data)
        
        let xmlDict = XmlJson(
            xmlString: data,
            mappings: [
                .array("trkseg", element: "trkpt"),
                .array("trk", element: "trkseg"),
                .textNode("ele"),
                .textNode("time"),
                .textNode("name"),
                .array("gpx", element: "wpt"),
                .array("wpt", element: "desc_"),
                .textNode("sym"),
                .textNode("category"),
                .textNode("signpost1"),
                .textNode("signpost2"),
                .textNode("signpost3"),
                .textNode("signpost4"),
                .textNode("elevation"),
                .textNode("ele")
            ],
            // NOTE: Mappings HAVE to return a primitive type (String, Double, Int, Bool)
            transformations: [
                .double("ele"),
                .double("lon"),
                .double("lat"),
                .dateStringToUnixSeconds("time"),
                .int("elevation"),
                
            ]
        )
        // print(xmlDict?.jsonString)
        // json model 만들기
        // json decoder 사용
        
        guard let jsonData = xmlDict?.data else {
            print("xmlDict?.data 가 없습니다.")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970

            decoded = try decoder.decode(Document.self, from: jsonData)
            print(decoded)
            
        } catch {
            print(error)
        }
        
    } catch let e {
        print(e.localizedDescription)
    }
    
    return decoded
    
}
