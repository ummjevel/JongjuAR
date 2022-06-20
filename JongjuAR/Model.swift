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
            enum CodingKeys: String, CodingKey {
                case lat
                case lon
                case ele
                case name
                case time = "time"
                case category
                case signpost1
                case signpost2
                case signpost3
                case signpost4
                case sym
                case date
            }
            
            let lat: Double
            let lon: Double
            let ele: Double
            let name: String
            let time: Int64
            let category: String
            var signpost1: Any
            var signpost2: Any
            var signpost3: Any
            var signpost4: Any
            let sym: String
            
            var date: Date { Date(timeIntervalSince1970: Double(time))}
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(lat, forKey: .lat)
                try container.encode(lon, forKey: .lon)
                try container.encode(ele, forKey: .ele)
                try container.encode(name, forKey: .name)
                try container.encode(time, forKey: .time)
                try container.encode(category, forKey: .category)
                try container.encode(String(describing: signpost1), forKey: .signpost1)
                try container.encode(String(describing: signpost2), forKey: .signpost2)
                try container.encode(String(describing: signpost3), forKey: .signpost3)
                try container.encode(String(describing: signpost4), forKey: .signpost4)
                try container.encode(sym, forKey: .sym)
                try container.encode(date, forKey: .date)
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                lat = try values.decode(Double.self, forKey: .lat)
                lon = try values.decode(Double.self, forKey: .lon)
                ele = try values.decode(Double.self, forKey: .ele)
                name = try values.decode(String.self, forKey: .name)
                time = try values.decode(Int64.self, forKey: .time)
                category = try values.decode(String.self, forKey: .category)
                sym = try values.decode(String.self, forKey: .sym)
                
                do {
                    signpost1 = try values.decode(String.self, forKey: .signpost1)
                } catch {
                    signpost1 = try values.decode(Dictionary<String,Data>.self, forKey: .signpost1)
                }
                do {
                    signpost2 = try values.decode(String.self, forKey: .signpost2)
                } catch {
                    signpost2 = try values.decode(Dictionary<String,Data>.self, forKey: .signpost2)
                }
                do {
                    signpost3 = try values.decode(String.self, forKey: .signpost3)
                } catch {
                    signpost3 = try values.decode(Dictionary<String,Data>.self, forKey: .signpost3)
                }
                do {
                    signpost4 = try values.decode(String.self, forKey: .signpost4)
                } catch {
                    signpost4 = try values.decode(Dictionary<String,Data>.self, forKey: .signpost4)
                }
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
