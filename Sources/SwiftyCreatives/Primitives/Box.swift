//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/09.
//

import Foundation

import Metal
import simd
import GLKit

public class Box {
    private static let shrinkScale: Float = 0.01
    private final class VertexPoint {
        static let A: simd_float3 = simd_float3(x: -1.0, y:   1.0, z:   1.0)
        static let B: simd_float3 = simd_float3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: simd_float3 = simd_float3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: simd_float3 = simd_float3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: simd_float3 = simd_float3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: simd_float3 = simd_float3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: simd_float3 = simd_float3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: simd_float3 = simd_float3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    private var vertexDatas: [Vertex] = []
    private var buffer: MTLBuffer
    private var pos: simd_float3
    private var rot: simd_float3
    private var scale: simd_float3
    public init(pos: simd_float3) {
        self.pos = pos
        self.rot = simd_float3.zero
        self.scale = simd_float3.one
        let modelPos = self.pos * Box.shrinkScale
        
        //  T, S, C, B, A, S, Q, T, R, C, D, A, R, Q
        vertexDatas = [
            Vertex(position: VertexPoint.T, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.S, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.B, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.A, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.S, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.Q, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.T, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.R, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.C, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.D, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.A, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.R, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
            Vertex(position: VertexPoint.Q, color: simd_float4.zero, modelPos: modelPos, modelRot: rot, modelScale: scale),
        ]
        buffer = ShaderCore.device.makeBuffer(bytes: vertexDatas, length: Vertex.memorySize * vertexDatas.count, options: [])!
    }
    public func setColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        let simdColor = simd_float4(r, g, b, a)
        vertexDatas[0].color = simdColor
        vertexDatas[1].color = simdColor
        vertexDatas[2].color = simdColor
        vertexDatas[3].color = simdColor
        vertexDatas[4].color = simdColor
        vertexDatas[5].color = simdColor
        vertexDatas[6].color = simdColor
        vertexDatas[7].color = simdColor
        vertexDatas[8].color = simdColor
        vertexDatas[9].color = simdColor
        vertexDatas[10].color = simdColor
        vertexDatas[11].color = simdColor
        vertexDatas[12].color = simdColor
        vertexDatas[13].color = simdColor
        updateBuffer()
    }
    public func setPosition(_ p: simd_float3) {
        self.pos = p * Box.shrinkScale
        vertexDatas[0].modelPos = self.pos
        vertexDatas[1].modelPos = self.pos
        vertexDatas[2].modelPos = self.pos
        vertexDatas[3].modelPos = self.pos
        vertexDatas[4].modelPos = self.pos
        vertexDatas[5].modelPos = self.pos
        vertexDatas[6].modelPos = self.pos
        vertexDatas[7].modelPos = self.pos
        vertexDatas[8].modelPos = self.pos
        vertexDatas[9].modelPos = self.pos
        vertexDatas[10].modelPos = self.pos
        vertexDatas[11].modelPos = self.pos
        vertexDatas[12].modelPos = self.pos
        vertexDatas[13].modelPos = self.pos
        updateBuffer()
    }
    public func setScale(_ s: simd_float3) {
        self.scale = s
        vertexDatas[0].modelScale = s
        vertexDatas[1].modelScale = s
        vertexDatas[2].modelScale = s
        vertexDatas[3].modelScale = s
        vertexDatas[4].modelScale = s
        vertexDatas[5].modelScale = s
        vertexDatas[6].modelScale = s
        vertexDatas[7].modelScale = s
        vertexDatas[8].modelScale = s
        vertexDatas[9].modelScale = s
        vertexDatas[10].modelScale = s
        vertexDatas[11].modelScale = s
        vertexDatas[12].modelScale = s
        vertexDatas[13].modelScale = s
        updateBuffer()
    }
    public func setRotation(_ r: simd_float3) {
        self.rot = r
        vertexDatas[0].modelRot = r
        vertexDatas[1].modelRot = r
        vertexDatas[2].modelRot = r
        vertexDatas[3].modelRot = r
        vertexDatas[4].modelRot = r
        vertexDatas[5].modelRot = r
        vertexDatas[6].modelRot = r
        vertexDatas[7].modelRot = r
        vertexDatas[8].modelRot = r
        vertexDatas[9].modelRot = r
        vertexDatas[10].modelRot = r
        vertexDatas[11].modelRot = r
        vertexDatas[12].modelRot = r
        vertexDatas[13].modelRot = r
        updateBuffer()
    }
    public func getScale() -> simd_float3 {
        return scale
    }
    public func getRotation() -> simd_float3 {
        return rot
    }
    public func getPosition() -> simd_float3 {
        return pos
    }
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexDatas.count)
    }
    private func updateBuffer() {
        buffer.contents().copyMemory(from: vertexDatas, byteCount: Vertex.memorySize * vertexDatas.count)
    }
}
