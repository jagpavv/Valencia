import UIKit
import AVFoundation

protocol SoundSelectedProtocol {
  func selectedSound(name: String)
}

let kAlarmSoundList: [String] = ["Bell", "Tickle", "None"]

class SoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
  var player: AVAudioPlayer?
  var selectedSoundIndex: Int = 0
  var selectedSoundName: String {
    get {
      return kAlarmSoundList[selectedSoundIndex]
    }
    set {
      if let index = kAlarmSoundList.index(of: newValue) {
        selectedSoundIndex = index
      } else {
        selectedSoundIndex = 0
      }
    }
  }
  var delegate: SoundSelectedProtocol?
  @IBOutlet weak var soundTableView: UITableView!
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isMovingFromParentViewController {
      if let isPlaying = player?.isPlaying, isPlaying {
        player?.stop()
        player = nil
      }
      delegate?.selectedSound(name: selectedSoundName)
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kAlarmSoundList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell")
    cell?.textLabel?.text = kAlarmSoundList[indexPath.row]
    cell?.accessoryType = indexPath.row == selectedSoundIndex ? .checkmark : .none
    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.setSelected(false, animated: true)

    // checkmark
    let oldCell = tableView.cellForRow(at: IndexPath(row: selectedSoundIndex, section: 0))
    oldCell?.accessoryType = .none
    selectedSoundIndex = indexPath.row
    cell?.accessoryType = .checkmark

    // play selected sound
    guard indexPath.row < kAlarmSoundList.count - 1 else {
      player?.stop()
      return
    }
    let resourcePath = URL(fileURLWithPath: Bundle.main.path(forResource: selectedSoundName, ofType: "mp3")!)
    playAudio(url: resourcePath)
  }

  func playAudio(url: URL) {
    do {
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      player?.play()
    } catch {
      print("Error")
    }
  }
}
