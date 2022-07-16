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

extension String {
    func upperCasedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}

extension UIImageView {
    func addBottomGradient() {
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight: CGFloat = 70
        let shadow = UIColor.white.withAlphaComponent(0.4).cgColor
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        self.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}
