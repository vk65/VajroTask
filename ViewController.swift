//
//  ViewController.swift
//  vajroTak
//
//  Created by Tirumala on 10/11/24.
//

import UIKit

class ProfileVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var profileTableView:UITableView!
    
    private var loadingBackgroundView: UIView!

    private var loadingIndicator: UIActivityIndicatorView!


        private var viewModel: GetProfileViewModel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupTableView()
            // Set up loading indicator
                   setupLoadingIndicator()
                   
                   // Fetch data
                   showLoadingIndicator()
           
            view.addSubview(loadingIndicator)
            viewModel = GetProfileViewModel()
            viewModel.reloadTableView = { [weak self] in
                self?.hideLoadingIndicator()
                DispatchQueue.main.async {
                    self?.profileTableView.reloadData()

                }            }
            viewModel.showError = { [weak self] errorMessage in
                self?.hideLoadingIndicator()
                self?.showAlert(message: errorMessage)
            }
            
            loadingIndicator.startAnimating()
        
           
            
            
            viewModel.fetchItems()
        }
        
        private func setupTableView() {
            profileTableView.delegate = self
            profileTableView.dataSource = self
            let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
            profileTableView.register(nib, forCellReuseIdentifier: "ProfileTableViewCell")
           // self.view.addSubview(tableView)
        }
    
    private func setupLoadingIndicator() {
            // Create the transparent background view
            loadingBackgroundView = UIView(frame: self.view.bounds)
            loadingBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // Semi-transparent black background
            loadingBackgroundView.isHidden = true  // Initially hidden
            
            // Create the activity indicator
            loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = loadingBackgroundView.center
            loadingBackgroundView.addSubview(loadingIndicator)
            
            // Add the background view to the main view
            self.view.addSubview(loadingBackgroundView)
        }
        
        // Show the loading indicator
        private func showLoadingIndicator() {
            loadingBackgroundView.isHidden = false
            loadingIndicator.startAnimating()
        }
        
        // Hide the loading indicator
        private func hideLoadingIndicator() {
            DispatchQueue.main.async {
                
                self.loadingBackgroundView.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
        
        // TableView DataSource Methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfItems
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            let item = viewModel.item(at: indexPath.row)
            cell.profileImage.imageFromUrl(urlString: item.image.src ?? "")
            cell.profileTitleLbl?.text = item.title
          //  cell.profileTitleLbl.font = UIFont.SemiBold(size: 16)
            cell.profileTitleLbl.textColor = .gray
          //  cell.profileSublB.font = UIFont.Regular(size: 14)
            cell.profileSublB.textColor = .gray
            let htmlString = item.summaryHTML
            let plainText = stripHTML(from: htmlString)
            cell.profileSublB.text = plainText
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ClassifiedViewController(nibName: "ClassifiedViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        let item = viewModel.item(at: indexPath.row)
        vc.htmlString = item.bodyHTML
       // present(vc, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    

        
        // Alert for error messages
        private func showAlert(message: String) {
            DispatchQueue.main.async {
                
                
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

extension ProfileVc {
    func stripHTML(from string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }
        do {
            let attributedString = try NSAttributedString(data: data,
                                                         options: [.documentType: NSAttributedString.DocumentType.html,
                                                                  .characterEncoding: String.Encoding.utf8.rawValue],
                                                         documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error parsing HTML: \(error)")
            return string
        }
    }
    
    
}



extension UIImageView {
    public func imageFromUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Start a background data task using URLSession
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Check for any errors or invalid data
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Create a UIImage from the data
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
                print("Failed to create image from data")
            }
        }.resume() // Don't forget to start the task
    }
}

