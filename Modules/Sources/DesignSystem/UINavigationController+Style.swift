import UIKit

public extension UINavigationController {

    static func styleMovieBro() {
        let appearence = UINavigationBar.appearance()

        appearence.tintColor = .red

        let image = UIImage(resource: .chevronLeft)

        appearence.backIndicatorImage = image
        appearence.backIndicatorTransitionMaskImage = image

        appearence.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}
