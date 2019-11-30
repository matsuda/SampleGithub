//
//  WebViewController.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/12/01.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var backButton: UIBarButtonItem! {
        didSet {
            backButton.isEnabled = false
        }
    }
    @IBOutlet private weak var forwardButton: UIBarButtonItem! {
        didSet {
            forwardButton.isEnabled = false
        }
    }
    private let progressView: UIProgressView = .init(progressViewStyle: .bar)
    private var estimatedProgressObserver: NSKeyValueObservation?
    private var titleObserver: NSKeyValueObservation?
    private var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupProgressView()
        setupEstimatedProgressObserver()
        loadWeb()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.scrollView.contentInset = {
            var inset = webView.scrollView.contentInset
            inset.bottom = toolbar.frame.height
            return inset
        }()
    }

    deinit {
        estimatedProgressObserver = nil
        titleObserver = nil
    }

    func configure(url: URL) {
        self.url = url
    }

    @IBAction func tapBackButton(_ sender: Any) {
        webView.goBack()
    }

    @IBAction func tapForwardButton(_ sender: Any) {
        webView.goForward()
    }
}

extension WebViewController {
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }

    private func setupProgressView() {
        guard let naviBar = navigationController?.navigationBar else {
            return
        }
        progressView.translatesAutoresizingMaskIntoConstraints = false
        naviBar.addSubview(progressView)
        progressView.isHidden = true
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: naviBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: naviBar.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: naviBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0),
        ])
    }

    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
        titleObserver = webView.observe(\.title) { [weak self] (webView, _) in
            self?.title = webView.title
        }
    }

    private func loadWeb() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
        UIView.animate(withDuration: 0.33, animations: {
            self.progressView.alpha = 1.0
        })
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward

        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 0.0
        }, completion: { isFinish in
            self.progressView.isHidden = isFinish
        })
    }
}
