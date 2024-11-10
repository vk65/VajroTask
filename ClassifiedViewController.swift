//
//  ClassifiedViewController.swift
//  vajroTak
//
//  Created by Tirumala on 10/11/24.
//

import UIKit
import WebKit

class ClassifiedViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var htmlString:String? 

    

    @IBOutlet weak var classWebview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        classWebview?.uiDelegate = self
        classWebview?.navigationDelegate = self
        classWebview?.loadHTMLString("\(String(describing: htmlString))", baseURL: nil)
        
        classWebview?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Enable zooming by setting min/max zoom scales
        classWebview.scrollView.minimumZoomScale = 1.0 // Minimum zoom level (default)
        classWebview.scrollView.maximumZoomScale = 4.0 // Maximum zoom level (you can adjust this)
        classWebview.scrollView.zoomScale = 1.0 // Initial zoom level
        // Set autoresizing mask for flexible width and height
        

        // Add the webView to the view
        
        // HTML String to display
        
        
        // Load the HTML string into the web view
        classWebview?.loadHTMLString(htmlString ?? "", baseURL: nil)
        addZoomButtons()

    }
    
    
    func addZoomButtons() {
            // Create a zoom in button
            let zoomInButton = UIButton(type: .system)
            zoomInButton.frame = CGRect(x: 200, y: 750, width: 30, height: 30)
        zoomInButton.tintColor = .gray
        zoomInButton.setImage(UIImage(named: "zoomin"), for: .normal)
            zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
            self.view.addSubview(zoomInButton)

            // Create a zoom out button
            let zoomOutButton = UIButton(type: .system)
            zoomOutButton.frame = CGRect(x: 280, y: 750, width: 30, height: 30)
        zoomOutButton.tintColor = .gray
        zoomOutButton.setImage(UIImage(named: "zoomout"), for: .normal)
            zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
            self.view.addSubview(zoomOutButton)
        }

        @objc func zoomIn() {
            // Zoom in by increasing the zoom scale
            let currentScale = classWebview.scrollView.zoomScale
            let newScale = currentScale * 1.2  // Zoom in by 20%
            setZoomScale(newScale)
        }

        @objc func zoomOut() {
            // Zoom out by decreasing the zoom scale
            let currentScale = classWebview.scrollView.zoomScale
            let newScale = currentScale * 0.8  // Zoom out by 20%
            setZoomScale(newScale)
        }

        func setZoomScale(_ scale: CGFloat) {
            let scrollView = classWebview.scrollView
            let maxScale = scrollView.maximumZoomScale
            let minScale = scrollView.minimumZoomScale

            // Ensure the zoom scale stays within bounds
            let clampedScale = min(max(scale, minScale), maxScale)
            scrollView.setZoomScale(clampedScale, animated: true)
        }
    }

