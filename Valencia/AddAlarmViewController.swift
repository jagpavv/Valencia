import UIKit
import Foundation

class AddAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectedCityProtocol, RepeatSelectionProtocol {

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var alarmOptionTableView: UITableView!

  var snoozeSwitch: UISwitch?
  var selectedCityInWorldClock: [String] = []
  var cityNameFor0Cell: String = ""
  var weekdays: [Bool] = [false, false, false, false, false, false, false]

  override func viewDidLoad() {
    super.viewDidLoad()
    loadCities()
  }

  func loadCities() {
    // retrive the saved citie
    guard let cities = UserDefaults.standard.stringArray(forKey: kSavedCities) else { return }
    selectedCityInWorldClock = cities
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SelectedCityListSegue" {
      let destination = segue.destination as! SelectedCityViewController
      destination.delegate = self
    } else if segue.identifier == "RepeatSegue" {
      let destination = segue.destination as! RepeatViewController
      destination.weekdays = weekdays
      destination.delegate = self
    }
  }

  // conform Protocol
  func tappedCity(city: String) {
    cityNameFor0Cell = city
    alarmOptionTableView.reloadData()
  }

  func selectedRepeat(weekdays: [Bool]) {
    self.weekdays = weekdays
    alarmOptionTableView.reloadData()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row != 4 ? "AlarmLabelCell" : "AlarmSwitchCell")
    cell?.textLabel?.text = ["City", "Repeat", "Label", "Sound", "Snooze"][indexPath.row]
    switch indexPath.row {
    case 0:
      cell?.detailTextLabel?.text = cityCellText()
    case 1:
      cell?.detailTextLabel?.text = repeatCellText()
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

    let cell = tableView.cellForRow(at: indexPath)!
    cell.setSelected(false, animated: true)

    if indexPath.row == 0 {
      performSegue(withIdentifier: "SelectedCityListSegue", sender: self)
    } else if indexPath.row == 1 {
      performSegue(withIdentifier: "RepeatSegue", sender: self)
    }
  }

  @IBAction func cancelTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  //cell 0
  func cityCellText() -> String {
    if selectedCityInWorldClock.isEmpty {
      return "Please chose city"
    } else {
      return cityNameFor0Cell.isEmpty ? String(selectedCityInWorldClock[0]) : cityNameFor0Cell
    }
  }

  //cell 1
  func repeatCellText() -> String {
    return RepeatViewController.reapeatText(weekdays: weekdays)
  }

  @objc func snoozeValueChanged(_ sender: Any) {
    print("switch")
  }
}
