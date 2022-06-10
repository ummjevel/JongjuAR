//
//  Util.swift
//  JongjuAR
//
//  Created by 전민정 on 6/9/22.
//

import Foundation
import UIKit

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
    let documentsUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationFileUrl = documentsUrl.appendingPathComponent("JongjuAR").appendingPathComponent(savedName)
    
    // Create URL to the source file you want to download
    let fileURL = URL(string: urlPath)
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    let request = URLRequest(url:fileURL!)
    
    // Make folder specified this app
    let folderPath = documentsUrl.appendingPathComponent("JongjuAR")
    if !FileManager.default.fileExists(atPath: folderPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true)
        } catch {
            print("Coundn't create directory for this app...")
        }
    }
    
    // Download file
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode)")
            }
            
            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
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
    let documentsUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationFileUrl = documentsUrl.appendingPathComponent("JongjuAR").appendingPathComponent(gpx)
    
    // Make folder specified this app if folder is not exists
    let folderPath = documentsUrl.appendingPathComponent("JongjuAR")
    if !FileManager.default.fileExists(atPath: folderPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true)
        } catch {
            print("Coundn't create directory for this app...")
        }
    }
    
    // Check exists
    if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
        return true
    } else {
        return false
    }
}

// Gpx parse
