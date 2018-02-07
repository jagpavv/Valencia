import UIKit

protocol CitySelectionProtocol {
  func citySelected(city: String)
}

class CitySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

  @IBOutlet weak var cityListSearchBar: UISearchBar!
  @IBOutlet weak var cityListTableView: UITableView!

  var delegate: CitySelectionProtocol?
  let sectionTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

  var timeZoneCity: [String] = []

  // result of searchBar searching
  var timeZoneCityFiltered: [String] = []

  var sectionValues: [[String]] = []

  var searchString = ""
  var isSearching: Bool {
    return searchString.count > 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let timeZone = TimeZone.knownTimeZoneIdentifiers
    for identifier in timeZone {
      if let cityName = identifier.split(separator: "/").last {
        timeZoneCity.append("\(cityName)")
      }
    }

    timeZoneCity = timeZoneCity.sorted()

    for keyword in sectionTitles {
      let result = timeZoneCity.filter { $0.hasPrefix(keyword) }
      sectionValues.append(result)
    }
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchString = searchText
    timeZoneCityFiltered = timeZoneCity.filter { $0.lowercased().contains(searchString.lowercased()) }
    cityListTableView.reloadData()
  }

  @IBAction func cancelTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return isSearching ? nil : sectionTitles[section]
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return isSearching ? nil : sectionTitles
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return isSearching ? 1 : sectionTitles.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearching ? timeZoneCityFiltered.count : sectionValues[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneCell")
    cell?.textLabel?.text =
      isSearching ? timeZoneCityFiltered[indexPath.row] : sectionValues[indexPath.section][indexPath.row]
    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCity = isSearching ? timeZoneCityFiltered[indexPath.row] : sectionValues[indexPath.section][indexPath.row]
    delegate?.citySelected(city: selectedCity)
    dismiss(animated: true, completion: nil)
  }
}
