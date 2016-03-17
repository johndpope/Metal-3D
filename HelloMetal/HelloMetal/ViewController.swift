//
//  ViewController.swift
//  HelloMetal
//
//  Created by Chris on 2015-01-24.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

import Metal

import SceneKit
//import QuartzCore

class ViewController: UIViewController {
    
    let swipeRec = UISwipeGestureRecognizer()
    let pinchRec = UIPinchGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    
    var lastRotation = CGFloat()

    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    var drawable: CAMetalDrawable! = nil
    var projectionMatrix: SCNMatrix4! = nil
    var lastFrameTimestamp: CFTimeInterval = 0.0
    
    var triangleToDraw: Triangle!
    var objectToDraw: Cube!
    
    var texture: Texture! = nil
    
    var camera: SCNCamera! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view did load\n")

        self.view.addGestureRecognizer(swipeRec)
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(panRec)
        self.view.addGestureRecognizer(rotateRec)
        
        swipeRec.addTarget(self, action: "swiped")
        pinchRec.addTarget(self, action: "pinched:")
        panRec.addTarget(self, action: "panned:")
        rotateRec.addTarget(self, action: "rotated:")
        
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .BGRA8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        projectionMatrix = SCNMatrix4Identity
        
        triangleToDraw = Triangle(device: device)
        objectToDraw = Cube(device: device)
        texture = Texture(name: "Default", ext: "jpg", device: device)
        
        
        camera = SCNCamera()
        camera.zNear = 0.01
        camera.zFar = 100.0
        camera.xFov = 2 * atan( tan(60 / 2) *
            (Double(self.view.bounds.size.width) / Double(self.view.bounds.size.height)))
        camera.yFov = 2 * atan( tan(91.49 / 2) *
            (Double(self.view.bounds.size.height) / Double(self.view.bounds.size.width)))
        
        
        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary!.newFunctionWithName("light_fragment")
        let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")
        
        //let fragmentProgram = defaultLibrary!.newFunctionWithName("texturedQuadFragment")
        //let vertexProgram = defaultLibrary!.newFunctionWithName("texturedQuadVertex")

        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram!
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        do{
            pipelineState = try device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        }catch
        {
            print("Failed to create pipeline state, error \n")
        }
        
        commandQueue = device.newCommandQueue()
        
        timer = CADisplayLink(target: self, selector: Selector("newFrame:"))
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    
    func render(){
        // TODO
        var worldModelMatrix = SCNMatrix4MakeTranslation(0.0, 0.0, -5.0)
        worldModelMatrix = SCNMatrix4Mult(SCNMatrix4MakeScale(0.5, 0.5, 0.5), worldModelMatrix)
        drawable = metalLayer.nextDrawable()
        //camera.setProjectionTransform(SCNMatrix4Translate(<#T##mat: SCNMatrix4##SCNMatrix4#>, <#T##x: Float##Float#>, <#T##y: Float##Float#>, <#T##z: Float##Float#>))
        projectionMatrix = camera.projectionTransform()
       
        objectToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix ,projectionMatrix: projectionMatrix, clearColor: MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0), texture: texture.texture)
        
        //triangleToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), texture: texture.texture)
       
    }
    
    func newFrame(displayLink: CADisplayLink){
        if lastFrameTimestamp == 0.0
        {
            lastFrameTimestamp = displayLink.timestamp
        }
        
        let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        gameloop(timeSinceLastUpdate: elapsed)
    }
    
    func swiped(){
        print("swipe\n", terminator: "")
    }
    
    func pinched(recognizer: UIPinchGestureRecognizer){
        print("pinch\n", terminator: "")
        recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1.0
    }
    
    func panned(recognizer: UIPanGestureRecognizer){
        print("pan\n", terminator: "")
        if recognizer.state == UIGestureRecognizerState.Began ||
            recognizer.state == UIGestureRecognizerState.Changed
        {
            if recognizer.translationInView(self.view).x > 100
                || recognizer.translationInView(self.view).x < -100
            {
            if recognizer.velocityInView(self.view).x > 0
            {
                objectToDraw.rotationX = 0.0
                objectToDraw.rotationY = 1.0
                objectToDraw.rotationZ = 0.0
                objectToDraw.rotation += 0.05
            }
            else
            {
                objectToDraw.rotationX = 0.0
                objectToDraw.rotationY = 0.0
                objectToDraw.rotationZ = 0.0
                objectToDraw.rotation -= 0.05
            }
            }
            if recognizer.translationInView(self.view).y > 100
                || recognizer.translationInView(self.view).y < -100
            {
            if recognizer.velocityInView(self.view).y > 0
            {
                objectToDraw.rotationX = 1.0
                objectToDraw.rotationY = 0.0
                objectToDraw.rotationZ = 0.0
                objectToDraw.rotation += 0.05
            }
            else
            {
                objectToDraw.rotationX = 1.0
                objectToDraw.rotationY = 0.0
                objectToDraw.rotationZ = 0.0
                objectToDraw.rotation -= 0.05
            }
            }
        }
    }
    
    func rotated(recognizer: UIRotationGestureRecognizer){
        print("rotate\n", terminator: "")
        recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        
        recognizer.rotation = 0.0
        
    }
    
    func gameloop(timeSinceLastUpdate timeSinceLastUpdate: CFTimeInterval){
        
        objectToDraw.updateWithDelta(timeSinceLastUpdate)
        autoreleasepool{
            self.render()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

