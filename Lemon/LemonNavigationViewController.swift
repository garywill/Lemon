//
//  LemonNavigationViewController.swift
//  Lemon
//
//  Created by X140Yu on 18/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

class LemonNavigationViewController: UINavigationController {

    override func viewDidLoad() {
      super.viewDidLoad()

      navigationBar.barTintColor = UIColor.lmNavDarkGrey
      navigationBar.isTranslucent = false
      navigationBar.titleTextAttributes = [
        NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font: UIFont(name: "Menlo-Regular", size: 20)!
      ]
    }


}
