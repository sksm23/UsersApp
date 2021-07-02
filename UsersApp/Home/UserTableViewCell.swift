//
//  UserTableViewCell.swift
//  UsersApp
//
//  Created by Sunil Kumar on 02/07/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    let homeModel = HomeModel()
    var likeButtonActionCallBack: ((UserDetails, Bool) -> Void)?
    var currentUser = UserDetails()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func prepareUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
        profileImageView.layer.masksToBounds = true
    }
    
    func configureCell(user: UserDetails, likedProfile: Bool) {
        currentUser = user
        nameLabel.text = user.name
        ageLabel.text = "Age: " + "\(user.age),"
        genderLabel.text = user.gender.capitalized
        likeButton.isSelected = likedProfile
        setUserImage(urlString: user.picture)
    }
    
    private func setUserImage(urlString: String) {
        homeModel.fetchUserImage(imageUrl: urlString) { [weak self] data, error in
            if let imageData = data {
                DispatchQueue.main.async {
                    self?.profileImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func likeButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        likeButtonActionCallBack?(currentUser, sender.isSelected)
    }
}
