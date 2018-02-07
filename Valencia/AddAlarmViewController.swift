import UIKit
import Foundation

class AddAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var alarmOptionTableView: UITableView!

  var snoozeSwitch: UISwitch?

  override func viewDidLoad() {

    super.viewDidLoad()

    //

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row != 4 ? "AlarmLabelCell" : "AlarmSwitchCell")
    cell?.textLabel?.text = ["City", "Repeat", "Label", "Sound", "Snooze"][indexPath.row]
    switch indexPath.row {
    case 0:
      cell?.detailTextLabel?.text = "cell0"
    case 1:
      cell?.detailTextLabel?.text = "cell01"
    case 2:
      cell?.detailTextLabel?.text = "cell02"
    case 3:
      cell?.detailTextLabel?.text = "cell03"
    default: // case 4:
      let sw = UISwitch(frame: CGRect())
      sw.addTarget(self, action: #selector(snoozeValueChanged(_:)), for: .valueChanged)
      sw.setOn(true, animated: false)
      cell!.accessoryView = sw
      snoozeSwitch = sw
    }

    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row < 4 else { return }

    print("selected: " + String(indexPath.row))
    if indexPath.row == 0 {
      performSegue(withIdentifier: "SelectedCityListSegue", sender: self)
    }
  }

  @objc func snoozeValueChanged(_ sender: Any) {
    print("switch")
  }

  @IBAction func cancelTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}
