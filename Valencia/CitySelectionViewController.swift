import UIKit

protocol CitySelectionProtocol {
  func citySelected(city: String)
}

class CitySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  let timeZone = TimeZone.knownTimeZoneIdentifiers
  var delegate: CitySelectionProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  @IBAction func cancelTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeZone.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneCell")
    cell?.textLabel?.text = timeZone[indexPath.row]

    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.citySelected(city: timeZone[indexPath.row])
    dismiss(animated: true, completion: nil)
  }

}
