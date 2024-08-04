//
//  UIExtensions.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 01/08/24.
//

import SwiftUI

struct Application {
    public static var scene: UIScene? {
        guard let scene = UIApplication.shared.connectedScenes.first else {
            return nil
        }
        
        return scene
    }
    
    public static var window: UIWindow? {
        
        guard let scene = self.scene,
              let delegate = scene.delegate as? UIWindowSceneDelegate,
              let window = delegate.window else {
            return nil
        }
        
        return window
    }
    
    public static var screen: UIScreen? {
        guard let window = self.window else {
            return nil
        }
        
        return window.screen
    }
}

extension View {
    var scene: UIScene? {
        return Application.scene
    }
    
    var window: UIWindow? {
        return Application.window
    }
    
    var screen: UIScreen? {
        return Application.screen
    }
    
    var screenWidth: CGFloat {
        return self.screen?.bounds.width ?? 0
    }
    
    var screenHeight: CGFloat {
        return self.screen?.bounds.height ?? 0
    }
}
