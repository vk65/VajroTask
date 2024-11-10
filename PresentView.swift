

import Foundation
import UIKit


struct PresentView  {
    static func showPicker(viewController: UIViewController, sourceBtn : UIButton, sourceField : UITextField = UITextField(), options : [String], completion: @escaping (String) -> Void){
        let vc = UIViewController()
        var selectedRow = 0
        let screenWidth = UIScreen.main.bounds.width - 10
        let screenHeight = CGFloat(options.count * 40)
        
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.delegate = viewController as? any UIPickerViewDelegate
        pickerView.dataSource = viewController as? any UIPickerViewDataSource
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sourceBtn
        alert.popoverPresentationController?.sourceRect = sourceBtn.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAlert) in
            
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (confirmAlert) in
            selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedNumber = options[selectedRow]
            //sourceField.text = selectedNumber
            completion(selectedNumber)
            
        }))
        //viewController.view.cornerRadiusV = 15
        viewController.present(alert, animated: true)
    }
    
    static func showPopup(poupView : UIView, viewController : UIViewController){
        let vc = UIViewController()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        vc.view.addSubview(poupView)
        viewController.present(vc, animated: true)
    }
    
    //    static func checkNetworkStatus(){
    //
    //        if let reachability = NetworkReachabilityManager(), !reachability.isReachable {
    //        guard let topview = UIApplication.shared.topMostViewController else {return}
    //        let details = NetworkVC(nibName: "NetworkVC", bundle: nil)
    //        details.modalPresentationStyle = .custom
    //        topview.present(details, animated: true)
    //            return
    //        }
    //
    //    }
    //
    //    static func showAPISuccessPopup(message:String, isError:Bool = false){
    //        guard let topview = UIApplication.shared.topMostViewController else {return}
    //        let imgStr = isError ? "Error" : "success"
    //        topview.showErrorView(image: UIImage(named: imgStr)! ,subtitle: message)
    //    }
    //
    //     func setAppearance(barBackColor: UIColor = .primary, titleColor: UIColor = .white){
    //
    //        if #available(iOS 15.0, *) {
    //            let navigationBarAppearance = UINavigationBarAppearance()
    //            navigationBarAppearance.configureWithOpaqueBackground()
    //            navigationBarAppearance.titleTextAttributes = [
    //                NSAttributedString.Key.foregroundColor : titleColor
    //            ]
    //            navigationBarAppearance.backgroundColor = barBackColor
    //            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    //            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    //            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    //
    //            let appearance = UITabBarAppearance()
    //            appearance.configureWithOpaqueBackground()
    //            appearance.backgroundColor = .primary
    //            UITabBar.appearance().standardAppearance = appearance
    //            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    //
    //        }
    //    }
    //}
    }

extension UIFont {
    
    static func Regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    static func SemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
}
