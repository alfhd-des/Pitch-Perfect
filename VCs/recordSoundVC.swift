//
//  recordSoundVC.swift
//  PitchPerfect
//
//  Created by Fares Alharbi on 10/07/1440 AH.
//  Copyright © 1440 Fares Alharbi. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundVC: UIViewController {
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    
    @IBOutlet weak var recordingLbl: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        configurUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func configurUI(recording: Bool) {
        
        if recording {
            
            recordingLbl.text = "Recording in progress"
            stopRecordingBtn.isEnabled = true
            recordBtn.isEnabled = false
            
        } else {
            
            recordingLbl.text = "Tap to Record"
            stopRecordingBtn.isEnabled = false
            recordBtn.isEnabled = true
            
        }
        
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        configurUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecordingSegue" {
            let destination = segue.destination as! playSoundsVC
            let recordedAudioURL = sender as! URL
            destination.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    
}

extension recordSoundVC: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
            
        } else {
            
            print("error occured")
            
        }
    }
    
}
