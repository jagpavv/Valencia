import UIKit

let kSavedCities = "SavedCities"

class WorldClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CitySelectionProtocol {

  @IBOutlet weak var worldClockTableView: UITableView!

  var selectedCityInWorldClock: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadCities()
    worldClockTableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CitySelectionSegue" {
      let navi = segue.destination as! UINavigationController
      let dest = navi.viewControllers.first as! CitySelectionViewController
      dest.delegate = self
    }
  }

  // conform Protocol
  func citySelected(city: String) {
    if !selectedCityInWorldClock.contains(city) {
      selectedCityInWorldClock.append(city)
      saveCities()
      worldClockTableView.reloadData()
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockCell")
    cell?.textLabel?.text = selectedCityInWorldClock[indexPath.row]
    return cell!
  }

}
