import UIKit

extension UIImage {

  func lm_cornerRadiused() -> UIImage? {
    return lm_cornerRadiused(self.size.width)
  }

  func lm_cornerRadiused(_ radius: CGFloat) -> UIImage? {
    let rect = CGRect(origin: .zero, size: self.size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    UIGraphicsGetCurrentContext()?.clip()
    draw(in: rect)
    UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
    let output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext()
    return output
  }

}
