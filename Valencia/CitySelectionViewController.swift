import UIKit

protocol CitySelectionProtocol {
  func citySelected(city: String)
}

class CitySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var delegate: CitySelectionProtocol?
  let sectionTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
  var sectionValues: [[String]] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    let timeZone = TimeZone.knownTimeZoneIdentifiers
    var timeZoneCity: [String] = [].sorted(by: < )
    for identifier in timeZone {
      if let cityName = identifier.split(separator: "/").last {
        timeZoneCity.append("\(cityName)")
      }
    }

    for keyword in sectionTitles {
      let result = timeZoneCity.filter { $0.hasPrefix(keyword) }
      sectionValues.append(result)
    }
  }

  @IBAction func cancelTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }


  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sectionTitles
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sectionValues[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneCell")
    cell?.textLabel?.text = sectionValues[indexPath.section][indexPath.row]
    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.citySelected(city: sectionValues[indexPath.section][indexPath.row])
    dismiss(animated: true, completion: nil)
  }

}
