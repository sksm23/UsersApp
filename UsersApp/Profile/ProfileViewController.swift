//
//  ProfileViewController.swift
//  UsersApp
//
//  Created by Sunil Kumar on 30/06/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var currentTextField: UITextField!
    //
    private let viewModel = ProfileViewModel()
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUI()
        bindViewModel()
        viewModel.retriveUserDetails()
    }
    
    private func prepareUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
        profileImageView.layer.masksToBounds = true
        saveButton.isHidden = viewModel.isLoggedInUser()
        // ImagePicker
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    private func updateUserDetails(userDetails: UserDetails) {
        userNameTextField.text = userDetails.name
        ageTextField.text = "\(userDetails.age)"
        genderTextField.text = userDetails.gender
        if let data = userDetails.pictureData {
            profileImageView.image = UIImage(data: data)
        }
    }
    
    //MARK: - Bind
    private func bindViewModel() {
        _ = viewModel.currentUser.asObservable().subscribe { [weak self] userDetails in
            DispatchQueue.main.async {
                self?.updateUserDetails(userDetails: userDetails)
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func saveButtonAction(_ sender: UIButton) {
        viewModel.userDetails.name = userNameTextField.text ?? ""
        viewModel.userDetails.age = Int16(ageTextField.text ?? "") ?? 0
        viewModel.userDetails.gender = genderTextField.text ?? ""
        viewModel.userDetails.pictureData = profileImageView.image?.pngData()
        viewModel.saveUserDetails()
        homeViewController()
    }
    
    @IBAction func pickProfilePhotoButtonAction(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    // navigation
    private func homeViewController() {
        if let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "aHomeViewController") as? HomeViewController {
            navigationController?.pushViewController(home, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTextField.resignFirstResponder()
    }
}

//MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//MARK: - ImagePickerDelegate
extension ProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        profileImageView.image = image
    }
}
