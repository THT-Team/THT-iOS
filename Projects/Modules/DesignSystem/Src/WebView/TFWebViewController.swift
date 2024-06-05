//
//  TFWebViewController.swift
//  DSKit
//
//  Created by Kanghos on 5/30/24.
//

import UIKit
import WebKit

import Core

public class TFWebViewController: TFBaseViewController {

  // MARK: - Properties
  private var webView: WKWebView?
  private let indicator = UIActivityIndicatorView(style: .medium)
  private let url: URL
  // MARK: - Lifecycle

  private let closeButton: UIBarButtonItem = .exit

  public init(title: String? = nil, url: URL) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func makeUI() {
    view.backgroundColor = .white
    setAttributes()
    setContraints()

    self.navigationItem.rightBarButtonItem = closeButton
  }

  private func setAttributes() {

    let configuration = WKWebViewConfiguration()

    webView = WKWebView(frame: .zero, configuration: configuration)
    self.webView?.navigationDelegate = self

    guard
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
    webView.addSubview(indicator)

    webView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    indicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

  }

  public override func bindViewModel() {
    closeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
}

extension TFWebViewController: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    indicator.startAnimating()
  }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
  }
}
