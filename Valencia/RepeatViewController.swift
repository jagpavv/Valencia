import UIKit

class RepeatViewController: UITableViewController {

  @IBAction func unwindRepeatSegue(_ sender: UIStoryboardSegue) {
  }

  var weekdays: [Int] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    performSegue(withIdentifier: "unwindRepeatSegue", sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    for weekday in weekdays {
      if weekday == (indexPath.row + 1) {
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
      }
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)!
    
    if let index = weekdays.index(of: (indexPath.row + 1)) {
      weekdays.remove(at: index)
      cell.setSelected(true, animated: true)
      cell.setSelected(false, animated: true)
      cell.accessoryType = UITableViewCellAccessoryType.none
    }
    else {
      weekdays.append(indexPath.row + 1)
      cell.setSelected(true, animated: true)
      cell.setSelected(false, animated: true)
      cell.accessoryType = UITableViewCellAccessoryType.checkmark
    }
  }
}

extension RepeatViewController {
  static func reapeatText(weekdays: [Int]) -> String {
    if weekdays.count == 7 {
      return "Every day"
    }

    if weekdays.isEmpty {
      return "Never"
    }

    var weekdayString = String()
    var weekdaysSorted: [Int] = [Int]()

    weekdaysSorted = weekdays.sorted(by: <)

    for day in weekdaysSorted {
      switch day {
      case 1:
        weekdayString += "sun "
      case 2:
        weekdayString += "Mon "
      case 3:
        weekdayString += "Tue "
      case 4:
        weekdayString += "Wed "
      case 5:
        weekdayString += "Thu "
      case 6:
        weekdayString += "Fri "
      case 7:
        weekdayString += "Sat "
      default:
        break
      }
    }
    return weekdayString
  }
}
