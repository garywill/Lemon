import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol EventViewModelInputs {
  var didTapLink: PublishSubject<URL?> { get }
}

public protocol EventViewModelOutputs {
  var linkURL: Driver<URL?> { get }
}

public protocol EventViewModelType {
  var inputs: EventViewModelInputs { get }
  var outputs: EventViewModelOutputs { get }
}

public final class EventCellViewModel: EventViewModelType, EventViewModelOutputs, EventViewModelInputs {

  public var outputs: EventViewModelOutputs { return self }
  public var inputs: EventViewModelInputs { return self }

  public var linkURL: Driver<URL?>
  public var didTapLink: PublishSubject<URL?>

  var eventAttributedString = NSAttributedString()
  var dateAttributedString = NSAttributedString()
  let linkAttributeName = "com.lemon.ios.linkAttributeName"
  var avatarURL: URL?
  var iconImage: UIImage?
  let event: GitHubEvent

  init(event: GitHubEvent) {

    self.event = event
    didTapLink = PublishSubject()
    linkURL = didTapLink.asDriver(onErrorJustReturn: nil)

    let attrString = NSMutableAttributedString()

    if let eventType = event.eventType {
      switch eventType {
      case .WatchEvent(let action):
        if let userName = event.actor?.login, let userURL = event.actor?.url?.lm_url {
          let userNameAttrString = NSAttributedString(string: userName,
                                                      attributes:
            [
              NSAttributedStringKey.foregroundColor: UIColor.lmGithubBlue,
              NSAttributedStringKey.font: UIFont.lemonMono(size: 17),
              NSAttributedStringKey(rawValue: linkAttributeName): userURL
            ])
          attrString.append(userNameAttrString)
        }
        let actionAttrString = NSAttributedString(string: " " + action + "\n", attributes:
          [
            NSAttributedStringKey.foregroundColor: UIColor.lmDarkGrey,
            NSAttributedStringKey.font: UIFont.lemonMono(size: 17)
          ]
        )
        attrString.append(actionAttrString)
        if let repo = event.repo?.name, let repoURL = event.repo?.url?.lm_url {
          let repoAttrString = NSAttributedString(string: repo, attributes:
            [
              NSAttributedStringKey.foregroundColor: UIColor.lmGithubBlue,
              NSAttributedStringKey.font: UIFont.lemonMono(size: 17),
              NSAttributedStringKey(rawValue: linkAttributeName): repoURL
            ])
          attrString.append(repoAttrString)
        }
        iconImage = #imageLiteral(resourceName: "event_star")
        break
      default:
        break
      }
    }

    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineSpacing = 3
    attrString.addAttributes([NSAttributedStringKey.paragraphStyle: paraStyle], range: NSRange(location: 0, length: attrString.length))
    eventAttributedString = attrString

    if let date = event.createdAt {
      dateAttributedString = NSAttributedString(string: date.lm_ago(), attributes:
        [
          NSAttributedStringKey.foregroundColor: UIColor.lmLightGrey,
          NSAttributedStringKey.font: UIFont.lemonMono(size: 14)
        ])
    }

    if let u = event.actor?.avatarUrl {
      avatarURL = URL(string: u)
    }
  }
}
