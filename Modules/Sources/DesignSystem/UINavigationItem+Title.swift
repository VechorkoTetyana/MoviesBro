import UIKit

public extension UINavigationItem {
    func setMoviesBroTitle(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .titleMed26
        titleLabel.textColor = .black
        titleView = titleLabel
    }
}
