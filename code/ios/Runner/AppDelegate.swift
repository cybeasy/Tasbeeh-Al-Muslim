import UIKit
import AVFAudio
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      initChanel()
      GeneratedPluginRegistrant.register(with: self)
      do {
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          UIApplication.shared.applicationIconBadgeNumber = 0

      }
      } catch {
        
      }
      
      // Get the singleton instance.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
      
      do {
          if #available(iOS 10.0, *){
              try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
              try AVAudioSession.sharedInstance().setActive(true)
          }
      } catch {
          print(error)
      }
//      let bundle = Bundle.main

//      let url = bundle.path(forResource: "a1_1", ofType: "mp3" )
//      print(url)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func initChanel()
    {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

                let channel = FlutterMethodChannel(name: "klib.flutter.dev/native",
                                                          binaryMessenger: controller.binaryMessenger)
                
                channel.setMethodCallHandler({
                    [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                    // Note: this method is invoked on the UI thread.
                    if call.method == "getFilePath" {
                        guard let args = call.arguments as? [String : Any] else {return}
                        let fileName = args["fileName"] as! String

                          self?.getFilePath(_fileName: fileName, result: result)
                    }
                    else  if call.method == "schedulingLocalNotificationInHour" {
                  

                          self?.schedulingLocalNotificationInHour(call: call, result: result)
                    }
                    else  if call.method == "cancelAllLocalNotification" {
                  

                          self?.cancelAllLocalNotification( )
                    }
                    else  if call.method == "cancelLocalNotification" {
                  

                          self?.cancelLocalNotification( call: call)
                    }
                    else  if call.method == "getPenddingLocalNotification" {
                  

                          self?.getPenddingLocalNotification(  result: result)
                    }
                    else {
                        result(FlutterError(code: "UNAVAILABLE",
                                            message: "invalid method name.",
                                            details: nil))
                    }
                })
    }
    
    
    private func getFilePath(_fileName:String ,result: FlutterResult) {

             let bundle = Bundle.main

     let url = bundle.path(forResource: _fileName, ofType: "" )
result(url)

        
       }
    
    
    private func schedulingLocalNotificationInHour (call: FlutterMethodCall ,result: FlutterResult) {

        
        guard let args = call.arguments as? [String : Any] else {return}
        print(args)
        
        let notficationId = args["notficationId"] as! String
        let title = args["title"] as! String
        let sound = args["sound"] as! String
        let minute = args["minute"] as! Double
        let payload = args["payload"] as! String
        
    
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.userInfo = ["payload": payload]
 
        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: sound))
        content.badge = 0 ;
        
//        let thisTime:TimeInterval = minute * 60.0
        
        // show this notification five seconds from now
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: thisTime, repeats: true)
        
        var date = DateComponents()
 
        date.minute = Int(minute)
     
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: notficationId, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        result(true)

        
       }
       
    private func cancelAllLocalNotification()
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

    }
    
    private func cancelLocalNotification(call: FlutterMethodCall )
    {
        guard let args = call.arguments as? [String : Any] else {return}
  
        let notficationId = args["notficationId"] as! String
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[notficationId])

    }
    
    
    private func getPenddingLocalNotification(result:  @escaping  FlutterResult)
    {
        let center = UNUserNotificationCenter.current()
        var repatingNotification:[String] = []

        center.getPendingNotificationRequests(completionHandler: { requests in
            
      
            for request in requests {
                print(request)
                repatingNotification.append(request.content.userInfo["payload"]  as? String ?? "")
            }
            
            result(repatingNotification)
        })
    }
    
    
  
    
   
}
