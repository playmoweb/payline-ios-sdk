//
//  PLWebViewControllerDelegate.swift
//  Nimble
//
//  Created by Rayan Mehdi on 26/02/2019.
//

import Foundation
import WebKit

protocol PLWebViewControllerDelegate: class {
    func plWebViewControllerDidFinishLoadingWithSuccess(_ plWebViewController: PLWebViewController)
    func plWebViewController(_ plWebViewController: PLWebViewController, didFinishLoadingWithError error: Error)
    func plWebViewController(_ plWebViewController: PLWebViewController, didReceive message: WKScriptMessage)
    func plWebViewControllerDidRequestClose(_ plWebViewController: PLWebViewController)
}
