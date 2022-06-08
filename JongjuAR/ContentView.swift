//
//  ContentView.swift
//  JongjuAR
//
//  Created by 전민정 on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var datas = ReadData()
    
    var body: some View {
        NavigationView {
            List(datas.jongjus) { jongju in
                Section(header: Text(jongju.name)) {
                    ForEach(jongju.routes) { route in
                        NavigationLink(destination: DownloadGPXView(route: route)) {
                            Text(route.name)
                        }
                    }
                    
                    
                }
            }
        }
        
    }
}

struct DownloadGPXView: View {
    var route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    var body: some View {
        List {
            ForEach(route.courses) { course in
                Text(course.name)
            }
        }
    }
}

class ReadData: ObservableObject {
    @Published var jongjus = [Jongju]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "Backdu", withExtension: "json") else {
            print("json not found...")
            return
        }
        let data = try? Data(contentsOf: url)
        do {
            let jongjus = try JSONDecoder().decode([Jongju].self, from: data!)
            self.jongjus = jongjus
        } catch {
            print(error)
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/*
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
*/
