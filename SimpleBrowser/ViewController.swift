import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UISearchBarDelegate {
	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var backButton: UIBarButtonItem!
	@IBOutlet weak var reloadButton: UIBarButtonItem!
	@IBOutlet weak var stopButton: UIBarButtonItem!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	// ホームページのURL。起動時にこのページを開く。
	let homeUrl = "http://www.yahoo.co.jp"
	
	// 検索機能で使うURL
	let searchUrl = "http://search.yahoo.co.jp/search?p="
	
	// URLのホワイトリスト。
	// このURLにあてはまればアプリ内ブラウザで表示許可。
	// 前方一致の正規表現で処理される。
	let whiteList = [
		"https?://.*\\.yahoo\\.co\\.jp",
		"https?://.*\\.yahoo\\.com",
	]
	
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
	
	// 文字列で指定されたURLをSafariで開く。
	func openUrlInSafari(urlString: String){
		if let nsUrl = NSURL(string: urlString) {
			UIApplication.sharedApplication().openURL(nsUrl)
		}
	}
	// 読込完了時の処理
	func stopLoading(){
		activityIndicator.alpha = 0
		activityIndicator.stopAnimating()
		backButton.enabled = webView.canGoBack
		reloadButton.enabled = true
		stopButton.enabled = false
	}
	
	// MARK: - UIWebViewDelegate
	func webViewDidStartLoad(webView: UIWebView) {
		activityIndicator.alpha = 1
		activityIndicator.startAnimating()
		backButton.enabled = false
		reloadButton.enabled = false
		stopButton.enabled = true
	}
	func webViewDidFinishLoad(webView: UIWebView) {
		stopLoading()
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request:
		NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
			// ユーザの操作によるリクエストでなければ表示許可。
			if navigationType == UIWebViewNavigationType.Other {
				return true;
			}
			// 現在表示中のURLを取得。
			var theUrl: String
			if let unwrappedUrl = request.URL?.absoluteString {
				theUrl = unwrappedUrl
			} else {
				// 現在表示中のURLが取得できない場合表示不許可。
				stopLoading()
				return false;
			}
			// ホワイトリストでループしてURLがホワイトリスト内にあるかチェック。
			var canStayInApp = false;
			for url in whiteList {
				if let match = theUrl.rangeOfString(url, options:
					NSStringCompareOptions.RegularExpressionSearch) {
						canStayInApp = true;
						break;
				}
			}
			// ホワイトリスト内に無ければSafariで開く。
			if !canStayInApp {
				openUrlInSafari(theUrl)
				stopLoading()
				return false;
			}
			return true
	}
	
	// MARK: - UISearchBarDelegate
	func searchBarSearchButtonClicked(searchBar: UISearchBar){
		if let searchText = searchBar.text {
			let url = searchUrl + searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
			openUrl(url)
			searchBar.resignFirstResponder()
		}
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

