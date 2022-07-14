import Foundation
import UIKit

extension UICollectionViewCell {
    
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(class: T.Type) {
        self.register(T.nibFile, forCellWithReuseIdentifier: T.identifier)
        print("Ok")
    }
}

extension UITableViewCell {
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(class: T.Type) {
        self.register(T.nibFile, forCellReuseIdentifier: T.identifier)
    }
}

