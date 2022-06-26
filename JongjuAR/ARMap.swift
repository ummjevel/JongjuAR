//
//  ARMap.swift
//  JongjuAR
//
//  Created by 전민정 on 6/26/22.
//

import Foundation
import UIKit
import SwiftUI
import SceneKit
import ARKit
import CoreLocation
import ARCL


struct ARMapView: View {
    
    // @State var document: Document
    
    var body: some View {
        ARMapRepresentation().edgesIgnoringSafeArea(.all)
    }
}

struct ARMapRepresentation: UIViewControllerRepresentable {
    
    // @State var document: Document
    
    func makeUIViewController(context: Context) -> ARMap {
        return ARMap() //(document: document)
    }
    
    func updateUIViewController(_ uiViewController: ARMap, context: Context) {
        
    }
}

class ARMap: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate {
    
    var sceneLocationView = SceneLocationView()
    var configuration = ARWorldTrackingConfiguration()
    //var document: Document?
    /*
    init(document: Document) {
        super.init(nibName: nil, bundle: nil)
        self.document = document
        print("called init...")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder called...")
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.bounds = self.view.frame
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
}
