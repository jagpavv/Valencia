import UIKit

protocol SelectedCityProtocol {
  func tappedCity(city: String)
}

class SelectedCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CitySelectionProtocol {
  
  @IBOutlet weak var selectedCityTableView: UITableView!
  var selectedCityInWorldClock: [String] = []
  var delegate: SelectedCityProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadCities()
    selectedCityTableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CityAddSegue" {
      let navi = segue.destination as! UINavigationController
      let dest = navi.viewControllers.first as! CitySelectionViewController
      dest.delegate = self
    }
  }

  func citySelected(city: String) {
    if !selectedCityInWorldClock.contains(city) {
      selectedCityInWorldClock.append(city)
      saveCities()
      selectedCityTableView.reloadData()
    }
  }

  func saveCities() {
    // saves the selected cities
    UserDefaults.standard.set(selectedCityInWorldClock, forKey: kSavedCities)
    UserDefaults.standard.synchronize()
  }

  func loadCities() {
    // retrive the saved citie
    guard let cities = UserDefaults.standard.stringArray(forKey: kSavedCities) else { return }
    selectedCityInWorldClock = cities
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedCityInWorldClock.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedCityCell")
    cell?.textLabel?.text = selectedCityInWorldClock[indexPath.row]
    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCity = selectedCityInWorldClock[indexPath.row]
    delegate?.tappedCity(city: selectedCity)
    navigationController?.popViewController(animated: true)
  }
}
