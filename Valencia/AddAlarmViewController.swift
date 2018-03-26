import UIKit
import Foundation

class AddAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectedCityProtocol, RepeatSelectionProtocol, LabelEditProtocol, SoundSelectedProtocol {

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var alarmOptionTableView: UITableView!

  var selectedCityInWorldClock: [String] = []
  var city: String = ""
  var repeats: [Bool] = [false, false, false, false, false, false, false]
  var label: String = "Alarm"
  var sound: String = kAlarmSoundList[0]
  var snooze: Bool = true

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
      destination.weekdays = repeats
      destination.delegate = self
    } else if segue.identifier == "LabelSegue" {
      let destination = segue.destination as! LabelEditViewController
      destination.text = label
      destination.delegate = self
    } else if segue.identifier == "SoundSegue" {
      let destination = segue.destination as! SoundViewController
      destination.selectedSoundName = sound
      destination.delegate = self
    }
  }

  // conform Protocol
  func tappedCity(city: String) {
    self.city = city
    alarmOptionTableView.reloadData()
  }

  func selectedRepeat(weekdays: [Bool]) {
    self.repeats = weekdays
    alarmOptionTableView.reloadData()
  }

  func editedLabel(text: String) {
    label = text
    alarmOptionTableView.reloadData()
  }

  func selectedSound(name: String) {
    sound = name
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
      cell?.detailTextLabel?.text = label
    case 3:
      cell?.detailTextLabel?.text = sound
    default: // case 4:
      let sw = UISwitch(frame: CGRect())
      sw.addTarget(self, action: #selector(snoozeValueChanged(_:)), for: .valueChanged)
      sw.setOn(snooze, animated: false)
      cell!.accessoryView = sw
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
    } else if indexPath.row == 2 {
      performSegue(withIdentifier: "LabelSegue", sender: self)
    } else if indexPath.row == 3 {
      performSegue(withIdentifier: "SoundSegue", sender: self)
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
      return city.isEmpty ? String(selectedCityInWorldClock[0]) : city
    }
  }

  //cell 1
  func repeatCellText() -> String {
    return RepeatViewController.repeatText(weekdays: repeats)
  }

  @objc func snoozeValueChanged(_ sender: Any) {
    guard let sw = sender as? UISwitch else { return }
    snooze = sw.isOn
  }
}
