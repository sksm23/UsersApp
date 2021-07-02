//
//  HomeViewController.swift
//  UsersApp
//
//  Created by Sunil Kumar on 01/07/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserList()
        viewModel.getLikedProfileList()
        bindViewModel()
        prepareUI()
    }
    
    private func prepareUI() {
        navigationItem.hidesBackButton = true
    }
    
    //MARK: - Bind
    private func bindViewModel() {
        _ = viewModel.usersList.asObservable().subscribe { [weak self] userDetails in
            self?.viewModel.segregateUsersWith(index: 0)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        viewModel.segregateUsersWith(index: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    @IBAction func profileBarButtonAction(_ sender: UIBarButtonItem) {
        profileViewController()
    }
    
    // navigation
    private func profileViewController() {
        if let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "aProfileViewController") as? ProfileViewController {
            navigationController?.pushViewController(profile, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "aUserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let userDetails = viewModel.userDetailsAt(index: indexPath.row)
        cell.configureCell(user: userDetails.0, likedProfile: userDetails.1)
        cell.likeButtonActionCallBack = { [weak self] currentUser, isLike in
            self?.viewModel.updateLikedProfile(user: currentUser, like: isLike)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
