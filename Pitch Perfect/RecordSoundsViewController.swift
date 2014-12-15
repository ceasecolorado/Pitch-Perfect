//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Cesar Colorado on 11/28/14.
//  Copyright (c) 2014 Cesar Colorado. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var Recording: UILabel!
    @IBOutlet weak var Microphone: UIButton!
    @IBOutlet weak var stopbutton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        Microphone.enabled = true
        stopbutton.hidden = true
        Recording.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        Recording.hidden = false
        stopbutton.hidden = false
        Microphone.enabled = false
        //TODO: Record the user's Voice
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        //TODO: STEP 2 - MOVE TO THE NEXT SCENE AKA PERFORM SEGUE
        self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        }else{
        println("Recording was not succesfull")
            Microphone.enabled = true
            stopbutton.hidden = true
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StopRecording") {
            let playsoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playsoundsVC.receivedAudio = data
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        Recording.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
}
