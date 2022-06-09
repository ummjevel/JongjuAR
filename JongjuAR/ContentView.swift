//
//  ContentView.swift
//  JongjuAR
//
//  Created by 전민정 on 6/6/22.
//

import SwiftUI
import CoreGPX

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
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showingAlert = false
    
    var route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    var body: some View {
        List {
            ForEach(route.courses) { course in
                Button {
                    // print(course.gpx)
                    // download 여부 확인
                    // true : open
                    // false : download
                    self.showingAlert = true
                    
                } label: {
                    Text(course.name)
                }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("GPX 파일을 다운로드 받으시겠습니까?"), message: Text("다운로드 받아야 경로를 확인할 수 있습니다."), primaryButton: .destructive(Text("OK")) {
                        print("다운로드받기!")
                    }, secondaryButton: .cancel())
                }
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
