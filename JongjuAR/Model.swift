//
//  Model.swift
//  JongjuAR
//
//  Created by 전민정 on 6/8/22.
//

import Foundation
import UIKit
import SwiftUI


// Backdu.json

struct Course : Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case num
        case name
        case mmap
        case gpx
        case gpxPath
    }
    var id = UUID()
    var num: Int
    var name: String
    var mmap: String
    var gpx: String
    var gpxPath: String
}

struct Route : Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case num
        case name
        case courseType
        case courseCnt
        case courses
    }
    var id = UUID()
    var num: Int
    var name: String
    var courseType: String
    var courseCnt: Int
    var courses: [Course]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        num = try values.decode(Int.self, forKey: .num)
        name = try values.decode(String.self, forKey: .name)
        courseType = try values.decode(String.self, forKey: .courseType)
        courseCnt = try values.decode(Int.self, forKey: .courseCnt)
        courses = try values.decode([Course].self, forKey: .courses)
    }
}

struct Jongju : Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case name
        case routes
    }
    var id = UUID()
    var name: String    // 백두대간
    var routes: [Route]
}

// for converted json from gpx file

struct Document: Codable {
    let gpx: Gpx

    struct Gpx: Codable {
        let version: String
        let wptElements: [WptElement]
        
        struct WptElement: Codable {
            let lat: Double
            let lon: Double
            let ele: Double
            let name: String
            let time: Int
            let category: String
            var signpost1: Any
            var signpost2: Any
            var signpost3: Any
            var signpost4: Any
            let sym: String
            
            var date: Date { Date(timeIntervalSince1970: Double(time))}
            
            func encode(to encoder: Encoder) throws {
                <#code#>
            }
            
            init(from decoder: Decoder) throws {
                <#code#>
            }
            
        }
        
        let trk: Trk

        struct Trk: Codable {
            let name: String
            let trksegElements: [TrksegElement]

            struct TrksegElement: Codable {
                let trkptElements: [TrkptElement]

                struct TrkptElement: Codable {
                    let lat: Double
                    let lon: Double
                    let ele: Double
                    let time: Double

                    var date: Date { Date(timeIntervalSince1970: time) }
                }
            }
        }
    }
}
