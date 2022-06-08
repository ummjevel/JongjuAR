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
    var tracks: [String] // 지리산권 종주: 8구간(gpx 파일), 덕유산권 종주, ....
}

let backduTracks = [
    "1. 지리산권 종주": ["1코스_천왕봉-세석산장", "2코스_세석산장-토끼봉", "3코스_토끼봉-헬기장", "4코스_헬기장-입망치", "5코스_입망치-매요마을", "6코스_매요마을-꼬부랑재", "7코스_꼬부랑재-중고개재"]
    , "2. 덕유산권 종주": ["1코스_중고개재-육십령", "2코스_육십령-삿갓골재", "3코스_삿갓골재-빼재(신풍령)", "4코스_빼재(신풍령)-쑥병이", "5코스_쑥병이-삼도봉", "6코스_삼도봉-바람재", "7코스_바람재-당마루", "8코스_당마루-큰재"]

]

let backduTrack = [
    "1. 지리산권 종주"
    , "2. 덕유산권 종주"
    , "3. 속리산권 종주"
    , "4. 소백산권 종주"
    , "5. 태백산권 종주"
    , "6. 오대산권 종주"
    , "7. 설악산권 종주"]
let hanyangTrack = ["1코스 북악산":[], "2코스 낙산":[], "2코스 남산":[], "4코스 인왕산":[]]

let backdu = Jongju(name: "백두대간", tracks: backduTrack)
// let hanyang = Jongju(name: "한양도성", tracks: hanyangTrack)

let data = [backdu]

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(backdu.name)) {
                    ForEach(backdu.tracks, id: \.self) { key in
                        NavigationLink(destination: DownloadGPXView(trackName: key, trackNames: backduTracks[key] ?? [])) {
                            Text(key)
                        }
                    }
                    
                    
                }
            }
        }
        
    }
}

struct DownloadGPXView: View {
    var trackName: String
    var trackNames: [String]
    
    init(trackName: String, trackNames: [String]) {
        self.trackName = trackName
        self.trackNames = trackNames
    }
    
    var body: some View {
        List {
            ForEach(trackNames, id: \.self) { value in
                Text(value)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
