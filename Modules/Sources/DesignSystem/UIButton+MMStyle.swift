import UIKit

public extension UIButton {
    func styleMoviesBro() {
        titleLabel?.font = .button24
        titleLabel?.textColor = .white
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        applyGradient(
            colours: [
                UIColor.darkRed,
                UIColor.red
            ])
    }
}

