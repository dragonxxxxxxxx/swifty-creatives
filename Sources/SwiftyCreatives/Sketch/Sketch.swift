//
//  Sketch.swift
//  
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import simd

open class Sketch: SketchBase {
    
    internal var customMatrix: [f4x4] = [f4x4.createIdentity()]
    
    public func getCustomMatrix() -> f4x4 {
        return self.customMatrix.reduce(f4x4.createIdentity(), *)
    }

    private(set) var privateEncoder: SCEncoder?
    
    public var LIGHTS: [Light] = [Light(position: f3(0, 10, 0), color: f3.one, brightness: 1, ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 50)]
    
    public init() {}
    
    // MARK: functions
    
    @MainActor
    open func setupCamera(camera: some MainCameraBase) {}
    
    @MainActor
    open func update(camera: some MainCameraBase) {}
    
    @MainActor
    open func draw(encoder: SCEncoder) {}
    
    public func beforeDraw(encoder: SCEncoder) {
        self.customMatrix = [f4x4.createIdentity()]
        self.privateEncoder = encoder
    }
    
    open func updateAndDrawLight(encoder: SCEncoder) {
        encoder.setFragmentBytes([LIGHTS.count], length: Int.memorySize, index: 2)
        encoder.setFragmentBytes(LIGHTS, length: Light.memorySize * LIGHTS.count, index: 3)
    }
    
    #if os(macOS)
    open func mouseDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseDragged(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseEntered(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func mouseExited(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func keyDown(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func keyUp(with event: NSEvent, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func viewWillStartLiveResize(camera: some MainCameraBase, viewFrame: CGRect) {}
    open func resize(withOldSuperviewSize oldSize: NSSize, camera: some MainCameraBase, viewFrame: CGRect) {}
    open func viewDidEndLiveResize(camera: some MainCameraBase, viewFrame: CGRect) {}
    #endif
    
    #if os(iOS)
    open func onScroll(delta: CGPoint, camera: some MainCameraBase, view: UIView, gestureRecognizer: UIPanGestureRecognizer) {}
    
    @MainActor
    open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    
    @MainActor
    open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    
    @MainActor
    open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    
    @MainActor
    open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: some MainCameraBase, view: UIView) {}
    #endif
}
