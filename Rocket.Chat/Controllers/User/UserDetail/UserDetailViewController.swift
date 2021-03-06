//
//  UserDetailViewController.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 6/26/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import FLAnimatedImage

class UserDetailViewController: BaseViewController, StoryboardInitializable {
    static var storyboardName: String = "UserDetail"

    @IBOutlet weak var backgroundImageView: FLAnimatedImageView!
    @IBOutlet weak var avatarImageView: FLAnimatedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var voiceCallButton: UIButton!
    @IBOutlet weak var videoCallButton: UIButton!

    override var isNavigationBarTransparent: Bool {
        return true
    }

    func updateButtonsInsets() {
        messageButton?.centerImageHorizontally()
        voiceCallButton?.centerImageHorizontally()
        videoCallButton?.centerImageHorizontally()
    }

    @IBOutlet weak var tableView: UserDetailTableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self

            if navigationController == nil {
                tableView.additionalTopInset = 44.0
            }
        }
    }

    var model: UserDetailViewModel = .emptyState {
        didSet {
            updateForModel()
        }
    }

    func updateForModel() {
        tableView?.reloadData()
        nameLabel?.text = model.name
        usernameLabel?.text = model.username
        if let url = model.avatarUrl, let avatar = avatarImageView, let background = backgroundImageView {
            ImageManager.loadImage(with: url, into: avatar)
            ImageManager.loadImage(with: url, into: background)
        }

        messageButton?.setTitle(model.messageButtonText, for: .normal)
        voiceCallButton?.setTitle(model.voiceCallButtonText, for: .normal)
        videoCallButton?.setTitle(model.videoCallButtonText, for: .normal)
        updateButtonsInsets()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateForModel()
    }

    @IBAction func messageDidPress(_ sender: UIButton) {
        AppManager.openDirectMessage(username: model.username)
    }
}

extension UserDetailViewController {
    func withModel(_ model: UserDetailViewModel) -> UserDetailViewController {
        self.model = model
        return self
    }
}

// MARK: Table View

extension UserDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsForSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailFieldCell") as? UserDetailFieldCell else {
            fatalError("Could not dequeue reusable cell 'UserDetailFieldCell'")
        }

        cell.model = model.cellForRowAtIndexPath(indexPath)

        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 13
    }
}
