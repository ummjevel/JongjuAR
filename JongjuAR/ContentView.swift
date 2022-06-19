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
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showingAlert = false
    @State private var showingErrorAlert = false
    @State private var showingDownloadedAlert = false
    @State var currentCourseGpx: String = ""
    @State var currentCourseGpxPath: String = ""
    let isDebug = true
    
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
                    if (IsDownloaded(gpx: course.gpx)) {
                        // open map
                        print("Downloaded!!!!!!!!")
                        ParseGPX(gpx: course.gpx)
                    } else {
                        // false : download
                        self.showingAlert = true
                        self.currentCourseGpx = course.gpx
                        self.currentCourseGpxPath = course.gpxPath
                    }
                    
                } label: {
                    Text(course.name)
                }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .alert("GPX 파일을 먼저 다운로드 받으시겠습니까? 다운로드 받아야 경로를 확인할 수 있습니다.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        let result = DownloadGpx(gpxPath: self.currentCourseGpxPath, gpxFile: self.currentCourseGpx)
                        
                        if(!result) {
                            showingErrorAlert = true
                        } else {
                            showingDownloadedAlert = true
                            // ParseGPX(gpx: course.gpx)
                        }
                    }
                    Button("Cancel", role: .destructive) {
                
                    }
                }
                .alert("에러가 발생하였습니다. 관리자에게 문의바랍니다.", isPresented: $showingErrorAlert) {
                    Button("OK", role: .cancel) {
                        
                    }
                }
                .alert("다운로드가 완료되었습니다.", isPresented: $showingDownloadedAlert) {
                    Button("OK", role: .cancel) {
                        
                    }
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
