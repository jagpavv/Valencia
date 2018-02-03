import UIKit

class WorldClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CitySelectionProtocol {

  @IBOutlet weak var worldClockTableView: UITableView!

  var selectedCityInWorldClock: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CitySelectionSegue" {
      let navi = segue.destination as! UINavigationController
      let dest = navi.viewControllers.first as! CitySelectionViewController
      dest.delegate = self
    }
  }

  func citySelected(city: String) {
    if !selectedCityInWorldClock.contains(city) {
      selectedCityInWorldClock.append(city)
      worldClockTableView.reloadData()
    }
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
