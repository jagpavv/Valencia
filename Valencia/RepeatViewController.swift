import UIKit

protocol RepeatSelectionProtocol {
  func selectedRepeat(weekdays: [Bool])
}

class RepeatViewController: UITableViewController {

  var delegate: RepeatSelectionProtocol?
  var weekdays: [Bool] = [false, false, false, false, false, false, false]

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isMovingFromParentViewController {
      delegate?.selectedRepeat(weekdays: weekdays)
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    cell.accessoryType = weekdays[indexPath.row] ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)!
    cell.setSelected(false, animated: true)
    weekdays[indexPath.row] = !weekdays[indexPath.row]
    cell.accessoryType = weekdays[indexPath.row] ? .checkmark : .none

  }
}

extension RepeatViewController {
  static func repeatText(weekdays: [Bool]) -> String {

    let all = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let selected = all.enumerated().flatMap { weekdays[$0.offset] ? $0.element : nil }

    if selected.isEmpty {
      return "Never"
    } else if selected.count == 7 {
      return "Every day"
    } else {
      let allWeekdays = Array(all[1...5])
      let allWeekends = all.filter { !allWeekdays.contains($0) }
      if selected == allWeekdays {
        return "Weekdays"
      } else if selected == allWeekends {
        return "Weekends"
      }
      return selected.joined(separator: " ")
    }
  }
}
