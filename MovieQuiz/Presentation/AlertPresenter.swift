import Foundation
import UIKit

class AlertPresenter {
    let model: AlertModel
    weak var viewController: UIViewController?
    
    init(model: AlertModel, viewController: UIViewController?) {
        self.model = model
        self.viewController = viewController
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: self.model.title,
            message: self.model.message,
            preferredStyle: .alert)
        guard let viewController = viewController else {return}
        let action = UIAlertAction(title: self.model.buttonText, style: .default) {[weak self] _ in
            guard let self = self else {return}
            self.model.completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
