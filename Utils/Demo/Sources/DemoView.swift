//
//  Copyright © 2020 sroik. All rights reserved.
//

import SwiftUI
import PocketSharing
import UtilsCore

struct DemoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("share json", action: shareJson)
            Button("share photo", action: sharePhoto)
        }
    }
    
    private func sharePhoto() {
        let url = Bundle.main.url(forResource: "image", withExtension: "jpg").fatal()
        let content = ShareContent(
            item: .file(url: url, type: .jpeg),
            caption: "This is a photo"
        )

        ShareService.shared.shareToPhotos(content: content) { success, _, error in
            if success {
                print("Successfully shared to photos")
            } else {
                print("Sharing failed with error: ", error?.localizedDescription ?? "none")
            }
        }
    }
    
    private func shareJson() {
        let url = Bundle.main.url(forResource: "file", withExtension: "json").fatal()
        let content = ShareContent(
            item: .file(url: url, type: .json),
            caption: "This is simple json file"
        )

        ShareService.shared.shareViaActivity(
            content: content,
            in: UIApplication.shared.topViewController.fatal()
        ) { success, activity in
            if let activity = activity, success {
                print("Successfully shared to: ", activity)
            } else {
                print("Sharing cancelled")
            }
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
