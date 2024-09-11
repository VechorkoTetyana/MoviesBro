import Foundation
import UIKit

enum FontName: String {
    case iBMPlexSansMediumItalic = "IBMPlexSans-MediumItalic"
    case iBMPlexSansItalic = "IBMPlexSans-Italic"
    case iBMPlexSansBoldItalic = "IBMPlexSans-BoldItalic"
   
}

public extension UIFont {
    static var titleBig48: UIFont {
        UIFont(name: FontName.iBMPlexSansBoldItalic.rawValue, size: 48)!
    }
    
    static var titleMed26: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 26)!
    }
    
    static var titleLit: UIFont {
        UIFont(name: FontName.iBMPlexSansItalic.rawValue, size: 18)!
    }
    
    static var subtitle18: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 18)!
    }
    
    static var subtitle16: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 16)!
    }
    
    static var subtitle14: UIFont {
        UIFont(name: FontName.iBMPlexSansItalic.rawValue, size: 14)!
    }
    
    static var textField18: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 18)!
    }
    
    static var textField14: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 14)!
    }
    
    static var button24: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 24)!
    }
    
    static var button20: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 20)!
    }
    
    static var otp24: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 24)!
    }
    
    static var navigationTitle26: UIFont {
        UIFont(name: FontName.iBMPlexSansBoldItalic.rawValue, size: 26)!
    }
    
    static var navigationTitle30: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 30)!
    }
    
    static var cardTitle30: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 30)!
    }
    
    static var cardDetailTitle22: UIFont {
        UIFont(name: FontName.iBMPlexSansMediumItalic.rawValue, size: 22)!
    }
}


