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
    
    var document: Document!
    
    init(courseGpx: String) {
        self.document = ParseGPX(gpx: courseGpx)
    }
    
    var body: some View {
        ARMapRepresentation(document: document).edgesIgnoringSafeArea(.all)
    }
}

struct ARMapRepresentation: UIViewControllerRepresentable {
    
    var document: Document
    
    func makeUIViewController(context: Context) -> ARMap {
        return ARMap(document: document)
    }
    
    func updateUIViewController(_ uiViewController: ARMap, context: Context) {
        
    }
}

class ARMap: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate {
    
    var sceneLocationView = SceneLocationView()
    var configuration = ARWorldTrackingConfiguration()
    var document: Document?
    
    init(document: Document) {
        super.init(nibName: nil, bundle: nil)
        self.document = document
        print("called init...")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder called...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        // sceneLocationView.delegate = self
        sceneLocationView.arViewDelegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setButtons()
    }
    
    private func setButtons() {
        
        let mapButton = UIButton(frame: CGRect(x: self.sceneLocationView.frame.width * 0.8 + 10, y: self.sceneLocationView.frame.height * 0.9 + 10, width: self.sceneLocationView.frame.width/9, height: self.sceneLocationView.frame.width/9))
        let mapImage = UIImage(systemName: "map.fill")// "arrow.clockwise.circle.fill")// "line.3.horizontal")
        mapButton.contentVerticalAlignment = .fill
        mapButton.contentHorizontalAlignment = .fill
        mapButton.tintColor = UIColor.white
        mapButton.setImage(mapImage, for: .normal)
        mapButton.addTarget(self, action: #selector(showButtons), for: .touchUpInside)
        
        self.sceneLocationView.addSubview(mapButton)
    }
    
    @objc func showButtons() {
        print("hello you pushed map button...")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus.rawValue > 2 {
            print("안녕?")
            setButtons()
        } else {
            setButtons()
        }
    }
    
}
