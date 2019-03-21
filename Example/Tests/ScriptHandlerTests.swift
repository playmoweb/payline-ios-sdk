//
//  FirstTest.swift
//  PaylineSDK_Tests
//
//  Created by MacBook on 3/5/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import WebKit
@testable import PaylineSDK

class TestScriptMessage: WKScriptMessage {
    
    private let _name: String
    override var name: String {
        return _name
    }
    private let _body: Any
    override var body: Any {
        return _body
    }
    
    init(name: String, body: Any) {
        _name = name
        _body = body
    }
}

class ScriptHandlerTest: QuickSpec {
    
    override func spec() {
        
        var scriptHandler: ScriptHandler!
        
        beforeEach {
            scriptHandler = ScriptHandler()
        }
        
        it("scriptHandler") {
            expect(scriptHandler.handledEvents).to(
                contain(
                    ScriptEvent.Name.didShowState,
                    ScriptEvent.Name.finalStateHasBeenReached,
                    ScriptEvent.Name.didEndToken
                )
            )
        }
        
        describe("didShowState") {
            
            it("paymentMethodsList") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.didShowState.rawValue, body: ["state": WidgetState.paymentMethodsList.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.didShowState(WidgetState.paymentMethodsList)))
                        done()
                    }
                }
            }
            
            it("manageWebWallet") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.didShowState.rawValue, body: ["state": WidgetState.manageWebWallet.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.didShowState(WidgetState.manageWebWallet)))
                        done()
                    }
                }
            }
            
            it("paymentRedirectNoResponse") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.didShowState.rawValue, body: ["state": WidgetState.paymentRedirectNoResponse.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.didShowState(WidgetState.paymentRedirectNoResponse)))
                        done()
                    }
                }
            }
        }
        
        describe("finalStateHasBeenReached") {
            
            it("paymentSuccess") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.paymentSuccess.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.paymentSuccess)))
                        done()
                    }
                }
            }
            
            it("paymentFailure") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.paymentFailure.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.paymentFailure)))
                        done()
                    }
                }
            }
            
            it("paymentCanceled") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.paymentCanceled.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.paymentCanceled)))
                        done()
                    }
                }
            }
            
            it("tokenExpired") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.tokenExpired.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.tokenExpired)))
                        done()
                    }
                }
            }
            
            it("browserNotSupported") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.browserNotSupported.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.browserNotSupported)))
                        done()
                    }
                }
            }
            
            it("paymentOnHoldPartner") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.paymentOnHoldPartner.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.paymentOnHoldPartner)))
                        done()
                    }
                }
            }
            
            it("paymentSuccessForceTicketDisplay") {
                
                let m = TestScriptMessage(name: ScriptEvent.Name.finalStateHasBeenReached.rawValue, body: ["state": WidgetState.paymentSuccessForceTicketDisplay.rawValue])
                
                waitUntil { done in
                    scriptHandler.handle(message: m) { event in
                        expect(event).to(equal(ScriptEvent.finalStateHasBeenReached(WidgetState.paymentSuccessForceTicketDisplay)))
                        done()
                    }
                }
            }
            
        }
    }
}
