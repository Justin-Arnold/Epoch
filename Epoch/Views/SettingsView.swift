//
//  SettingsView.swift
//  Epoch
//
//  Created by Justin Arnold on 12/9/23.
//

import Foundation
import AVFoundation
import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("baseTimeInMinutes") private var baseTimeInMinutes: Int = 25
    @AppStorage("selectedAlarmSound") private var selectedAlarmSound: String = "marimba.mp3"
    
    @State private var audioPlayer: AVAudioPlayer?
    
    let timeOptions = Array(1...60)
    let mp3Files = loadMp3Files()
    
    func playSound(soundName: String) {
        // Directly use the file name without any string manipulation
        let soundNameWithoutExtension = soundName.components(separatedBy: ".mp3").first ?? soundName

        // Attempt to construct the URL for the sound file
        guard let url = Bundle.main.url(forResource: soundNameWithoutExtension, withExtension: "mp3", subdirectory: "Alarms") else {
            print("Sound file not found for resource name: \(soundNameWithoutExtension)")
            return
        }

        print("URL for sound file: \(url)")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error setting up audio session or playing sound: \(error)")
        }
    }

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    Picker("Base Time", selection: $baseTimeInMinutes) {
                        ForEach(timeOptions, id: \.self) { time in
                            Text("\(time) minutes")
                        }
                    }
                }
                Section(header: Text("Alarm Sound")) {
                    Picker("Select Sound", selection: $selectedAlarmSound) {
                        ForEach(mp3Files, id: \.self) { mp3File in
                            Text(mp3File)
                        }
                    }
                    Button("Play Sound") {
                        playSound(soundName: selectedAlarmSound)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
    
}

func loadMp3Files() -> [String] {
    guard let folderURL = Bundle.main.resourceURL?.appendingPathComponent("Alarms", isDirectory: true) else {
        print("Alarms folder not found in the bundle.")
        return []
    }

    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let mp3Files = fileURLs.filter { $0.pathExtension == "mp3" }.map { $0.deletingPathExtension().lastPathComponent }
        print("Found MP3 files: \(mp3Files)") // Debugging statement
        return mp3Files
    } catch {
        print("Error while enumerating files \(folderURL.path): \(error.localizedDescription)")
        return []
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
