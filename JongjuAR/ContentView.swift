//
//  ContentView.swift
//  JongjuAR
//
//  Created by 전민정 on 6/6/22.
//

import SwiftUI

struct Jongju : Identifiable {
    var id = UUID()
    var name: String    // 백두대간
    var tracks: [String:Int] // 지리산권 종주: 8구간(gpx 파일), 덕유산권 종주, ....
}

let backduTrack = ["1. 지리산권 종주":8, "2. 덕유산권 종주":8, "3. 속리산권 종주":8, "4. 소백산권 종주":8, "5. 태백산권 종주":8, "6. 오대산권 종주":8, "7. 설악산권 종주":8]
let hanyangTrack = ["1코스 북악산":1, "2코스 낙산":1, "2코스 남산":1, "4코스 인왕산":1]

let backdu = Jongju(name: "백두대간", tracks: backduTrack)
let hanyang = Jongju(name: "한양도성", tracks: hanyangTrack)

let data = [backdu]

struct ContentView: View {
    
    
    var body: some View {
        
        return NavigationView {
            List {
                ForEach(data.indices) { index in
                    Section(header: Text(data[index].name)) {
                        ForEach(data[index].tracks.sorted(by: <), id: \.key) { key, value in
                            NavigationLink(destination:DownloadGPXView(trackName: key, trackCount: value), label: { Text(key)
                            })
                        }
                    }
                }
            }
        }.navigationTitle("AR Navigator")
        
    }
}

struct DownloadGPXView: View {
    var trackName: String
    var trackCount: Int
    
    init(trackName: String, trackCount: Int) {
        self.trackName = trackName
        self.trackCount = trackCount
    }
    
    var body: some View {
        List {
            ForEach(0..<self.trackCount, id: \.self) { index in
                Text("DownloadGPX View")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
