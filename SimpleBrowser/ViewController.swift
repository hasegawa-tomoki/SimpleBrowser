import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var backButton: UIBarButtonItem!
	@IBOutlet weak var reloadButton: UIBarButtonItem!
	@IBOutlet weak var stopButton: UIBarButtonItem!
	
	// ホームページのURL。起動時にこのページを開く。
	let homeUrl = "http://www.yahoo.co.jp"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// ホームページを開く。
		openUrl(homeUrl)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// 文字列で指定されたURLをWeb Viewで開く。
	func openUrl(urlString: String){
		let url = NSURL(string: urlString)
		let urlRequest = NSURLRequest(URL: url!)
		webView.loadRequest(urlRequest)
	}
	
	// MARK: - IBAction
	@IBAction func backButtonTapped(sender: UIBarButtonItem) {
		webView.goBack()
	}
	@IBAction func reloadButtonTapped(sender: UIBarButtonItem) {
		webView.reload()
	}
	@IBAction func stopButtonTapped(sender: UIBarButtonItem) {
		webView.stopLoading()
	}
}

