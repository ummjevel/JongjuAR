//
//  Util.swift
//  JongjuAR
//
//  Created by 전민정 on 6/9/22.
//

import Foundation
import UIKit

// gpx download
func DownloadGpx(gpxPath: String) -> Bool {
    // url 유효한지 확인 비어있으면 비었다고
    let url = URL(fileURLWithPath: gpxPath)
    
    URLSession.shared.dataTask(with: url) { data, resp, err in
        guard let resp = resp as? HTTPURLResponse else {
            print("not http url...")
            return false }
        if (200..<300).contains(resp.statusCode) {
            // url 유효함.
            
        } else {
            
        }
    }.resume()
            
    // 폴더 경로 지정
    
    // 다운로드
    
    return true
}

// gpx file search
func IsDownloaded(gpx: String) -> Bool {
    // 저장해놓는 폴더 경로에서 찾아보기.
    
    return true
}

// gpx parse
