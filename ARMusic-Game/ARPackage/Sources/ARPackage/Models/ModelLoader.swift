//
//  InstrumentModel.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Foundation
import Combine
import UIKit
import AudioPackage

public class ModelLoader {
    private static var cancellables = Set<AnyCancellable>()
    private static var models: [String: CharacterEntity] = [:]

    public required init() {}

    public static func load(name: String, completion: @escaping (Entity?) -> Void) {
        // Verifica se o modelo já está no cache
        if let model = models[name] {
            completion(model.clone(recursive: true))
            return
        }
        
        // Obtém a URL do recurso do modelo
        guard let url = Bundle.module.url(forResource: name, withExtension: "usdz") else {
            fatalError("Model '\(name)' not found.")
        }

        // Carrega o modelo de forma assíncrona
        Entity.loadModelAsync(contentsOf: url)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    print("DEBUG - unable to load model entity for modelName: \(name). Error: \(error)")
                    completion(nil)
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                // Armazena o modelo carregado no cache
                
                let characterEntity = CharacterEntity.fromModelEntity(modelEntity)
                
                self.models[name] = characterEntity
                // Retorna um clone do modelo carregado
                completion(characterEntity.clone(recursive: true))
                print("DEBUG - successfully loaded model entity for modelName: \(name)")
            })
            .store(in: &cancellables)
    }
}


