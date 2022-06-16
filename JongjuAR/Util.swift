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
    // url 유효한지 확인 비어있으면 비었다고
    var result = false
    let url = URL(fileURLWithPath: gpxPath)
    
    URLSession.shared.dataTask(with: url) { data, resp, err in
        guard let resp = resp as? HTTPURLResponse else {
            print("Not http url...")
            return }
        if (200..<300).contains(resp.statusCode) { // url 유효
            // download
            result = DownloadFileFromUrl(urlPath: gpxPath, savedName: gpxFile)
        } else {
            return
        }
    }.resume()
            
    return result
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
func ParseGPX(gpx: String) {
    
    let isDebug = true
    
    // IsDownloaded
    /*
    let isDownloaded = IsDownloaded(gpx: gpx)
    
    if (!isDownloaded) {
        print("Is Not Downloaded...")
        return
    }
     */
    
    // get file
    if(isDebug) {
        // 지금은 그냥 옆에 저장되어있는 것 불러오도록 하고,
        do {
            var destinationFileUrl: String = fileManger.currentDirectoryPath
                // .appendingPathComponent("백두대간_지리산권_종주_1코스.gpx")
            destinationFileUrl.append(contentsOf: "백두대간_지리산권_종주_1코스.gpx")
            let dataPath = URL(fileURLWithPath: destinationFileUrl)
            let dataFromPath: Data = try Data(contentsOf: dataPath)
            let data: String = String(data: dataFromPath, encoding: .utf8) ?? ""
            print(data)
        } catch let e {
            print(e.localizedDescription)
        }
        
    } else {
        // 이후에는 폴더 경로에서 불러와야함.
        // Create destination URL
        do {
            let destinationFileUrl = documentsUrl.appendingPathComponent("JongjuAR").appendingPathComponent(gpx)
            let dataFromPath: Data = try Data(contentsOf: destinationFileUrl)
            let data: String = String(data: dataFromPath, encoding: .utf8) ?? ""
            print(data)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    // parse file
    
}
