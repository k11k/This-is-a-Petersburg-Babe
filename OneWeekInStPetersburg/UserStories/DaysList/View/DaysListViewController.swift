//
//  DaysListViewController.swift
//  OneWeekInStPetersburg
//
//  Created by jsmirnova on 30.05.2018.
//  Copyright © 2018 Julia Smirnova. All rights reserved.
//

import UIKit

class DaysListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выбор дня"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        presentRouteVC()
    }
}


// Routing
extension DaysListViewController {
    func presentRouteVC() {
        let view = RouteMapViewController(nibName: "RouteMapViewController", bundle: nil)
        navigationController?.pushViewController(view, animated: true)
    }
}
