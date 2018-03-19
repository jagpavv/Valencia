import UIKit
import Foundation

protocol LabelEditProtocol {
  func editedLabel(text: String)
}

class LabelEditViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var textField: UITextField!
  var delegate: LabelEditProtocol?
  var text: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    textField.text = text
    self.textField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isMovingFromParentViewController, let txt = textField.text {
      delegate?.editedLabel(text: txt)
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    navigationController?.popViewController(animated: true)
    return true
  }
}
