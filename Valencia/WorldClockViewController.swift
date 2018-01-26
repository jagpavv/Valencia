import UIKit

class WorldClockViewController: UIViewController, CitySelectionProtocol {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func citySelected(city: String) {
    print("HI: " + city)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CitySelectionSegue" {
      let navi = segue.destination as! UINavigationController
      let dest = navi.viewControllers.first as! CitySelectionViewController
      dest.delegate = self
    }
  }

}
