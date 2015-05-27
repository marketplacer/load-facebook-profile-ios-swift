//  
//  A shortcut to run code asynchronously, in the main queue or after a delay.
//

import Foundation

public class TegQ {
  public class func async(block: ()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
  }
  
  public class func main(block: ()->()) {
    dispatch_async(dispatch_get_main_queue(), block)
  }
  
  public class func runAfterDelay(delaySeconds: Double, block: ()->()) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delaySeconds * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
  }
}
