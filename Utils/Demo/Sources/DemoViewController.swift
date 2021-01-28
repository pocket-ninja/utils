//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import PocketSharing
import UtilsCore

final class DemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        after(1.0) {
            self.share()
        }
    }
    
    private func share() {
        let url = Bundle.main.url(forResource: "file", withExtension: "json").fatal()
        let content = ShareContent(item: .file(url), caption: "This is simple json file")
        
        ShareService.shareViaActivity(content: content, in: self) { success, activity in
            if let activity = activity, success {
                print("Successfully shared to: ", activity)
            } else {
                print("Sharing cancelled")
            }
        }
    }
}
