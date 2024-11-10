//
//  EditProfileVC.swift
//  LastMinuteApp
//
//  Created by Mac on 10/07/23.
//

import UIKit
import GooglePlaces

class EditProfileVC: BaseVC {
    
    
    @IBOutlet weak var tblPlaces: UITableView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    var userProfile: GetProfile!
    @IBOutlet weak var addressTxtField: UITextField!
    // var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var provinceTextField: UITextField!
    // let clientVM = ClientAddressViewModel()
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    lazy var getProfileVM : GetProfileViewModel = {
        GetProfileViewModel(_GetProfileService: GetUserProfileService())
    }()
    
    private var tableDataSource: GMSAutocompleteTableDataSource!
    var location = CLLocationCoordinate2D()
    
    var saveTap : (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        self.navigationItem.title = "Edit Profile"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primary]
        //emailUsBtn.layerGradient()
        isBackPrimary = false
        addBackBarButton()
        placesSetup()
        nameTextField.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)
        txtLastName.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)
        // userProfile = getProfileVM.profileInfo.first
        
        //        else{
        //
        //        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createUserDataProfile()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.primary]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.primary]
        
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        isBackPrimary = true
        addBackBarButton()
        
    }
    
    func placesSetup(){
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        tblPlaces.delegate = tableDataSource
        tblPlaces.dataSource = tableDataSource
        tblPlaces.register(UITableViewCell.self, forCellReuseIdentifier: "places_cell")
        if #available(iOS 15.0, *) {
            tblPlaces.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    func createUserDataProfile(){
        if let firstN = userProfile.output.firstName, let lastN = userProfile.output.lastName {
            nameTextField.text = firstN
            txtLastName.text = lastN
        }
        
        emailTextField.text = userProfile.output.email ?? ""
        emailTextField.isUserInteractionEnabled = false
        addressTxtField.text = userProfile.output.address ?? ""
        cityTxtField.text = userProfile.output.city ?? ""
        provinceTextField.text = userProfile.output.province ?? ""
        txtPostalCode.text = userProfile.output.postalCode ?? ""
        txtPhone.text = userProfile.output.phoneNumber?.format("NNN NNN NNNN", oldString: userProfile.output.phoneNumber ?? "")
        enableSave()
        //  saveBtn.layerGradient(radius: saveBtn.frame.height/2)
    }
    
    
    func updateProfile() {
        
        saveBtn.isEnabled = true
        Loader.sharedInstance.showLoader()
        
        var dict : [String:Any] = [String:Any]()
        dict["address"] = self.addressTxtField.text ?? ""
        dict["city"] = self.cityTxtField.text ?? ""
        dict["province"] = self.provinceTextField.text ?? ""
        dict["postalCode"] = self.txtPostalCode.text ?? ""
        dict["firstName"] = nameTextField.text ?? ""
      //  dict["email"] = self.emailTextField.text ?? ""
        dict["lastName"] = txtLastName.text ?? ""
        let phone = self.phoneTxt.text!.format("NNNNNNNNNNNN", oldString: self.phoneTxt.text!)
        dict["phoneNumber"] =  phone.trim()
        dict["isProfileUpdate"] = true
        dict["userType"] = 3
        let locations = [location.longitude,location.latitude]
        dict["location"] = ["type": "Point","coordinates":locations]
        getProfileVM.updateProfile(params: dict)
        
        getProfileVM.setDataToScreen = {
            let details = DashboardVC(nibName: "DashboardVC", bundle: nil)
            Loader.sharedInstance.hideLoader()
            self.showErrorView(image: UIImage(named: "success")!,title: "Profile updated successfully",buttonTap:   {
                self.navigationController?.popViewControllerWithHandler(completion: {
                    self.saveTap?()
                })
            })
        }
    }
    
    
    
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        validateProfile()
    }
    
    
    func validateProfile() {
        if nameTextField.text == "" {
            //self.showErrorView(subtitle:"Please Enter First Name")
        } else if cityTxtField.text == "" {
            // self.showErrorView(subtitle:"Please Enter Last Name")
        } else if addressTxtField.text == "" {
            //  self.showErrorView(subtitle:"Please Select Valid Address")
        } else {
            updateProfile()
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case addressTxtField:
            var text = ""
            text = textField.text ?? ""
            //  print("Address -> \(text ?? "empty")")
            if text == "" {
                UIView.animate(withDuration: 0.3) {
                    self.tblPlaces.isHidden = true
                }
            }else{
                UIView.animate(withDuration: 0.3) {
                    self.tblPlaces.isHidden = false
                }
            }
            
            
        default:
            debugPrint("invalid text")
        }
        var isEnable = false
        if !addressTxtField.text!.isEmpty && !cityTxtField.text!.isEmpty && !provinceTextField.text!.isEmpty && !txtPostalCode.text!.isEmpty && txtPostalCode.text!.count >= 6 && addressTxtField.text!.count >= 6{
            isEnable = true
            
        }
        enableGradientButton(isEnable)
    }
    
    @objc private func editingChanged(sender: UITextField) {
        if let text = sender.text, text.count >= 15 {
            sender.text = String(text.dropLast(text.count - 15))
            return
        }
    }
    
    func setupUI() {
        self.emailTextField.isUserInteractionEnabled = false
        self.tblPlaces.isHidden = true
        self.addressTxtField.delegate = self
        nameTextField.setPlaceHolderFont(fontName: WixMadeforDisplay.regular.rawValue, iPhoneSize: 16, iPadSize: 22, placeHolderText: "First Name")
        txtLastName.setPlaceHolderFont(fontName: WixMadeforDisplay.regular.rawValue, iPhoneSize: 16, iPadSize: 22, placeHolderText: "Last Name")
        emailTextField.setPlaceHolderFont(fontName: WixMadeforDisplay.regular.rawValue, iPhoneSize: 16, iPadSize: 22, placeHolderText: "Enter your email")
        phoneTxt.setPlaceHolderFont(fontName: WixMadeforDisplay.regular.rawValue, iPhoneSize: 16, iPadSize: 22, placeHolderText: "Phone Number")
        addressTxtField.attributedPlaceholder(string: "Address")
        cityTxtField.attributedPlaceholder(string: "City")
        provinceTextField.attributedPlaceholder(string: "Province")
        txtPostalCode.attributedPlaceholder(string: "Postal Code")
        saveBtn.addRightImage(iPhoneFont: 16, iPadFont: 24, btnText: ConstantString.Save.rawValue,addImage: false)
        nameTextField.delegate = self
        
        [addressTxtField].forEach { txtfield in
            txtfield.addTarget(self,
                               action: #selector(self.textFieldDidChange(_:)),
                               for: UIControl.Event.editingChanged)
        }
        //        NotificationCenter.default.addObserver(
        //            self,
        //            selector: #selector(self.keyboardWillShow),
        //            name: UIResponder.keyboardWillShowNotification,
        //            object: nil)
        //
        //        NotificationCenter.default.addObserver(
        //            self,
        //            selector: #selector(self.keyboardWillHide),
        //            name: UIResponder.keyboardWillHideNotification,
        //            object: nil)
        
    }
    
    func enableGradientButton(_ isEnabled: Bool) {
        self.saveBtn.isEnabled = isEnabled
        if saveBtn.isEnabled {
            saveBtn.layerGradient(radius: saveBtn.frame.height/2)
        } else {
            saveBtn.removerGradientLayer()
            saveBtn.cornerRadiusV = 25
        }
        
    }
    
    
    
}

extension EditProfileVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enableSave()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        enableSave()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == self.nameTextField || textField == self.txtLastName || textField == self.emailTextField || textField == self.txtPhone || textField == self.addressTxtField || textField == self.txtPostalCode || textField == self.provinceTextField || textField == self.cityTxtField {
            enableSave()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        
        if textField == self.addressTxtField {
            guard let txt = textField.text else {
                return true
            }
            tableDataSource.sourceTextHasChanged(txt)
            let filter = GMSAutocompleteFilter()
            filter.countries = ["CA"]
            tableDataSource.autocompleteFilter = filter
            
        }
        var lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if txtPostalCode == textField {
            let str = lastText.unformat("XXX XXX", oldString: text)
            if str.containsSpecialCharacter { return false }
            textField.text = lastText.format("XXX XXX", oldString: text)
            // clientVM.postalCode = textField.text ?? ""
            return false
        } else if textField == provinceTextField || textField == cityTxtField {
            return string.containsLowerCaseCharacter || string.containsUpperCaseCharacter || string == "" || string == " "
        }
        
        //  let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if txtPhone == textField {
            if string.count > 2 && string.containsSpecialCharacter{
                lastText = lastText.digitString
            }
            textField.text = lastText.format("NNN NNN NNNN", oldString: text)
            let text = (txtPhone.text ?? "").trim()
            txtPhone.textColor = .black
            let isValid = !text.isEmpty && text.count > 11
            enableGradientButton(isValid)
            if isValid {
                txtPhone.resignFirstResponder()
            }
            return false
        }else if textField == nameTextField || textField == txtLastName {
            return string.containsLowerCaseCharacter || string.containsUpperCaseCharacter || string == "" || string == " "
        }
        return true
    }
    
    private func enableSave(){
        nameTextField.delegate = self
        txtLastName.delegate = self
        addressTxtField.delegate = self
        emailTextField.delegate = self
        txtPhone.delegate = self
        addressTxtField.delegate = self
        provinceTextField.delegate = self
        cityTxtField.delegate = self
        txtPostalCode.delegate = self
        
        let isValidCreds = !self.emailTextField.text!.isEmpty && self.emailTextField.text!.isValidEmail && !self.nameTextField.text!.isEmpty &&
        !self.txtLastName.text!.isEmpty && !self.addressTxtField.text!.isEmpty && !self.provinceTextField.text!.isEmpty  && !self.cityTxtField.text!.isEmpty && !self.txtPostalCode.text!.isEmpty && self.nameTextField.text!.count >= 3 && self.addressTxtField.text!.count >= 3 && self.cityTxtField.text!.count >= 3 && self.txtPostalCode.text!.count >= 3 && self.txtPhone.text!.count >= 8
        
        if isValidCreds{
            self.saveBtn.alpha = 1
            self.saveBtn.layerGradient(radius: saveBtn.frame.height/2)
        }else{
            self.saveBtn.alpha = 1
            self.saveBtn.removerGradientLayer()
            self.saveBtn.cornerRadiusV = 25
        }
    }
    
}



//MARK: - UITextField Delegates
//extension EditProfileVC : UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField == self.addressTxtField {
//            guard let txt = textField.text else {
//                return true
//            }
//                tableDataSource.sourceTextHasChanged(txt)
//
////             let filter = GMSAutocompleteFilter()
////             filter.countries = ["CA"]
////             tableDataSource.autocompleteFilter = filter
//
//                }
//
//        guard let text = textField.text else {
//            return true
//        }
//        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
////
//        if txtPostalCode == textField {
//            let str = lastText.unformat("XXX XXX", oldString: text)
//            if str.containsSpecialCharacter { return false }
//            textField.text = lastText.format("XXX XXX", oldString: text)
//           // clientVM.postalCode = textField.text ?? ""
//            return false
//        } else if textField == txtProvince || textField == txtCity {
//            return string.containsLowerCaseCharacter || string.containsUpperCaseCharacter || string == "" || string == " "
//        }
//        return true
//    }
//}


extension EditProfileVC: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        // UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        tblPlaces.reloadData()
    }
    //
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        tblPlaces.reloadData()
    }
    //
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        
        var stNumber = ""
        var street = ""
        var floor = ""
        if let components = place.addressComponents  {
            for i in components {
                
                switch(i.type){
                case "street_number","premise" :
                    stNumber = i.name
                case "subpremise":
                    print("1")
                    print(i.name)
                    floor = i.name
                case "route","sublocality_level_3":
                    street = i.name
                case "sublocality_level_2":
                    street = street + ", " + i.name
                    
                case "sublocality_level_1":
                    print("2")
                    print(i.name)
                case "locality":
                    print("3")
                    print(i.name)
                    self.cityTxtField.text = i.name
                    self.cityTxtField.isUserInteractionEnabled = false
                case "administrative_area_level_1":
                    print("4")
                    print(i.name)
                    self.provinceTextField.text = i.name
                    self.provinceTextField.isUserInteractionEnabled = false
                case "postal_code":
                    self.txtPostalCode.text = i.name
                    self.txtPostalCode.isUserInteractionEnabled = false
                default:
                    break
                }
            }
        }
        
        self.location = place.coordinate
        self.addressTxtField.text = stNumber + " " + street + " " + floor
        
        UIView.animate(withDuration: 0.3) {
            self.tblPlaces.isHidden = true
            self.addressTxtField.resignFirstResponder()
            self.enableGradientButton(true)
        }
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}


class NavigationController : UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }
        return .default
    }
}
