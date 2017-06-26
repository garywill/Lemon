//
//  StarButton.swift
//  Lemon
//
//  Created by X140Yu on 26/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

class StarButton: CountButton {

  var repoName: String? {
    didSet {
      guard let name = repoName else { return }
      GitHubProvider
        .request(.StarStatus(repoName: name))
        .subscribe(onNext: { res in
          if res.statusCode == 204 {
            self.currentState = .positive
          } else {
            self.currentState = .normal
          }
        })
        .addDisposableTo(bag)
    }
  }

  func handleStarButtonTouched() {
    guard let u = repoName else { return }
    switch self.currentState {
    case .busy,
         .disable:
      return
    case .positive:
      self.currentState = .busy
      GitHubProvider
        .request(.UnStarRepo(repoName: u))
        .subscribe(onNext: { res in
          if res.statusCode == 204 {
            self.currentState = .normal
          } else {
            self.currentState = .positive
          }
        }, onError: { error in
          self.currentState = .positive
        }).addDisposableTo(bag)
    case .normal:
      self.currentState = .busy
      GitHubProvider
        .request(.StarRepo(repoName: u))
        .subscribe(onNext: { res in
          if res.statusCode == 204 {
            self.currentState = .positive
          } else {
            self.currentState = .normal
          }
        }, onError: { error in
          self.currentState = .normal
        }).addDisposableTo(bag)
    }
  }

  override func update(_ state: CountButtonState) {
    super.update(state)

    switch state {
    case .positive:
      setImage(#imageLiteral(resourceName: "button_star_unstar"), for: .normal)
    case .busy:
      setImage(nil, for: .normal)
    default:
      setImage(#imageLiteral(resourceName: "Button_star_normal"), for: .normal)
    }
  }

  override func setup() {
    super.setup()

    addTarget(self, action: #selector(handleStarButtonTouched), for: .touchUpInside)
  }

}
