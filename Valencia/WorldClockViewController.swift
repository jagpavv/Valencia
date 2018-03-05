import UIKit

let kSavedCities = "SavedCities"

class WorldClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CitySelectionProtocol {

  var selectedCityInWorldClock: [String] = []
  var timer: Timer? = nil

  @IBOutlet weak var worldClockTableView: UITableView!

  // edit delete
  @IBAction func EditButton(_ sender: UIBarButtonItem) {
    if worldClockTableView.isEditing {
      sender.title = "Edit"
      worldClockTableView.setEditing(false, animated: true)
    } else {
      sender.title = "Done"
      worldClockTableView.setEditing(true, animated: true)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadCities()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let indexPaths = self?.worldClockTableView.indexPathsForVisibleRows else { return }
      for indexPath in indexPaths {
        let cell = self?.worldClockTableView.cellForRow(at: indexPath)
        if let city = self?.selectedCityInWorldClock[indexPath.row] {
          cell?.detailTextLabel?.text = self?.timeStringFrom(city)
        }
      }
    })
    worldClockTableView.reloadData()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if timer != nil {
      timer?.invalidate()
      timer = nil
    }
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
    let city = selectedCityInWorldClock[indexPath.row]

    cell?.textLabel?.text = city
    cell?.detailTextLabel?.text = timeStringFrom(city)

    return cell!
  }

  func timeStringFrom(_ city: String) -> String {
    let timeZone = TimeZone.knownTimeZoneIdentifiers.filter { $0.contains(city) }
    return timeWithTimeZone(date: Date(), timezone: TimeZone(identifier: timeZone[0])!)
  }

  // get date from TimeZone
  func timeWithTimeZone(date: Date, timezone: TimeZone) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    formatter.timeZone = timezone
    return formatter.string(from: date)
  }

  // swipe delete
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      selectedCityInWorldClock.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
      saveCities()
    }
  }

  // move row
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let temp1 = selectedCityInWorldClock[sourceIndexPath.row]
    let temp2 = selectedCityInWorldClock[destinationIndexPath.row]

    selectedCityInWorldClock[sourceIndexPath.row] = temp2
    selectedCityInWorldClock[destinationIndexPath.row] = temp1

    worldClockTableView.reloadData()
  }
}
