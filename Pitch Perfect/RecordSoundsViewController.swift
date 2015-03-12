//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Corpac on 3/9/15.
//  Copyright (c) 2015 Jeff Corpac. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var isPaused:Bool!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
        recordButton.enabled = true;
        lblRecording.text = "Tap to Record"
        pauseButton.hidden = true
        isPaused = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false;
        stopButton.hidden = false;
        pauseButton.hidden = false
        lblRecording.text = "Recording..."
        
        //Record the user's audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmSS"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var audioSession:AVAudioSession! = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioSession.setActive(true, error: nil)
        
        // If the isPaused flag is set, skip the initialization.
        // Otherwise, set up the audioRecorder for a new recording.
        if(!isPaused){
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        isPaused = false
        audioRecorder.record()
    }
    
    @IBAction func PauseRecording(sender: UIButton) {
        recordButton.enabled = true
        lblRecording.text = "Recording Paused - Tap Microphone to Continue"
        stopButton.hidden = true
        pauseButton.hidden = true
        isPaused = true
        audioRecorder.pause()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //Step 1 - Save the Recorded Audio
            recordedAudio = RecordedAudio(url:recorder.url, title:recorder.url.lastPathComponent)
        
            //Step 2 - Perform segue to move to the next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            lblRecording.text = "Tap to Record"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordButton.enabled = true;
        stopButton.hidden = true;
        pauseButton.hidden = true;
        isPaused = false
        lblRecording.text = "Tap to Record"

        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

