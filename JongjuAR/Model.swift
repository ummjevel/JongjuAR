//
//  Model.swift
//  JongjuAR
//
//  Created by 전민정 on 6/8/22.
//

import Foundation

struct Course : Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case num
        case name
        case mmap
        case gpx
    }
    var id = UUID()
    var num: Int
    var name: String
    var mmap: String
    var gpx: String
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


