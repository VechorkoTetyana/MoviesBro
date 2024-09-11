import UIKit

enum Tab {
    case home
    case chats
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "Home", image: .home, tag: 0)
        case .chats:
            return UITabBarItem(title: "Chats", image: .chats, tag: 0)
        }
    }
}
