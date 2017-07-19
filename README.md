# MPMediaItem+CanAddToLibrary
###A Swift extension to let you know if an MPMediaItem exists in your library

Since iOS 9.3 it has been possible to add Apple Music tracks to your library as such:

	let library = MPMediaLibrary()
	library.addItem(withProductID: id) { (entity, error) in
		if let error = error {
			NSLog("Error: \(error.localizedDescription)")
		}
	}

This is powerful as you can use a simple identifier to both play a song and add it to your library but it is likely your UI will want to show an add to library button similar to the Music app on iOS. To remedy this, here is a simple extension for MPMediaItem that tells you if a currently playing track is available in your library.

	import UIKit
	import MediaPlayer

	extension MPMediaItem {

	    var canAddToLibrary: Bool {
	        let id = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID)
	        let query = MPMediaQuery(filterPredicates: [id])
	        let count = query.items?.count ?? 0
	        return count == 0
	    }
	    
	}

Why an extension on MPMediaItem? The only way to know if a track is in your library is to search the user library with an `MPMediaQuery`. Unfortunately you can't search on  the `MPMediaItemPropertyPlaybackStoreID` (as some tracks may not be on Apple Music) so instead you need to use the persistent ID property. If you try and play an Apple Music track using an identifier, then you can retrieve an MPMediaItem and use that to get the persistent ID for searching. I use this in my own apps by listening to the `MPMusicPlayerControllerNowPlayingItemDidChange` notification and then checking if there is a `nowPlayingItem` on my `MPMusicPlayerController` instance; if there is then I check it to find the current status:

	var player = MPMusicPlayerController()

	override func viewDidLoad() {
	    super.viewDidLoad()
	    
	    player.beginGeneratingPlaybackNotifications()
	    NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
	}


	@objc func playbackStateDidChange() {
	    
	    guard let item = player.nowPlayingItem else {
	        return
	    }

	    // at this point we do not know if the track can be added - any UI for adding should be hidden

	    if item.canAddToLibrary {
	    	// show your "Add to library" button
	    } else {
	    	// show some UI to explain "Already in library"
	    }

	}


I am fairly sure this is how the Music app works on iOS as you'll notice when skipping tracks that the UI for the track status is completely hidden until the track is ready to play at which point either an add button or a tick will appear.

**IMPORTANT:** The user will need to have granted permission to access their media library in order for this extension to work. It will crash your app if you do not have NSAppleMusicUsageDescription in your Info.plist (although that is the bare minimum - you should actively check for capabilities before using this as no point showing an "Add to library" button if the user doesn't have that capability!

