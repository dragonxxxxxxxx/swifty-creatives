//
//  SketchSample2.swift
//  ExampleiOSApp
//
//  Created by Yuki Kuwashima on 2022/12/27.
//

import SwiftyCreatives
import UIKit

final class SketchSample2: Sketch {
    
    var viewObj = UIViewObject()
    var r: Float = 0.0
    var rFinal: Float = 0.0
    
    override init() {
        super.init()
        let view: TestView = TestView.fromNib()
        view.layer.cornerRadius = 36
        view.onHit = {
            self.rFinal += Float.pi / 2
        }
        viewObj.load(view: view)
        viewObj.multiplyScale(6)
    }
    
    override func update(camera: some MainCameraBase) {
        if r < rFinal {
            r += 0.06
            viewObj.setRot(f3(0, 0, r))
        }
    }
    
    override func draw(encoder: MTLRenderCommandEncoder) {
        viewObj.draw(encoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {
        let touch = touches.first!
        let location = touch.location(in: view)
        let processed = camera.screenToWorldDirection(x: Float(location.x), y: Float(location.y), width: Float(view.frame.width), height: Float(view.frame.height))
        let origin = processed.origin
        let direction = processed.direction
        viewObj.buttonTest(origin: origin, direction: direction)
    }
}

class TestView: UIView {
    
    var onHit: (() -> Void)?
    
    @IBAction func onButtonTap() {
        if let onHit = onHit {
            onHit()
        }
    }
}
