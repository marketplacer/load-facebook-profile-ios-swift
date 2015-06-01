import Quick
import Nimble
import KIFFramework

extension QuickSpec {
  func tester(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: self)
  }
  
  func system(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
  }
  
  override public func failWithException(exception: NSException!, stopTest stop: Bool) {
    if let userInfo = exception.userInfo {
      fail(exception.description,
        file: userInfo["SenTestFilenameKey"] as! String,
        line: userInfo["SenTestLineNumberKey"] as! UInt)
    } else {
      fail(exception.description)
    }
  }
}