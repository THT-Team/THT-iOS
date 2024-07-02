//
//  PostCodeWebViewController.swift
//  SignUp
//
//  Created by kangho lee on 4/29/24.
//

import UIKit
import WebKit

import Core
import DSKit
import SignUpInterface

public class PostCodeWebViewController: TFBaseViewController {
  
  enum WebViewKey: String {
    case bridge = "callBackHandler"
    case jibunAddress
    
  }
  
  // MARK: - Properties
  var webView: WKWebView?
  let indicator = UIActivityIndicatorView(style: .medium)
  var address = ""
  
  weak var delegate: WebViewDelegate?
  
  // MARK: - Lifecycle
  
  public override func makeUI() {
    view.backgroundColor = .white
    setAttributes()
    setContraints()
    
  }
  
  private func setAttributes() {
    let contentController = WKUserContentController()
    contentController.add(self, name: WebViewKey.bridge.rawValue)
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = contentController
    
    webView = WKWebView(frame: .zero, configuration: configuration)
    self.webView?.navigationDelegate = self
    
    guard let url = URL(string: "https://ibcylon.github.io/DaumAPI/"),
          let webView = webView
    else { return }
    let request = URLRequest(url: url)
    webView.load(request)
    indicator.startAnimating()
  }
  
  private func setContraints() {
    guard let webView = webView else { return }
    view.addSubview(webView)
    view.backgroundColor = .clear
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    webView.addSubview(indicator)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
      
      indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
    ])
  }
}

extension PostCodeWebViewController: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if message.name == WebViewKey.bridge.rawValue {
      if let data = message.body as? [String: Any] {
        if let address = data[WebViewKey.jibunAddress.rawValue] as? String {
          var formatted = address.components(separatedBy: " ")
          var returnValue = ""
          if formatted[0] != "서울" {
            formatted.removeFirst()
          } else {
            formatted[0] = "서울시"
          }
          returnValue = formatted.prefix(3).joined(separator: " ")
          self.delegate?.didReceiveAddress(returnValue)
        }
      }
    }
    self.dismiss(animated: true, completion: nil)
  }
}

extension PostCodeWebViewController: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    indicator.startAnimating()
  }
  
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
  }
}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct Location_ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//      let vm = LocationInputViewModel(locationservice: LocationService())
//      let vc = LocationInputViewController(viewModel: vm)
//      return vc.showPreview()
//    }
//}
//#endif
//
//
