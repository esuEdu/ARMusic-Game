//
//  InstrumentModel.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Foundation
import Combine

public class ModelLoader {
    private static var cancellables = Set<AnyCancellable>()
    private static var models: [String: Entity] = [:]

    public required init() {}

    public static func load(intrumentName: String, modelname:String, completion: @escaping (Entity?) -> Void) {
        // Verifica se o modelo já está no cache
        if let model = models[intrumentName] {
            completion(model.clone(recursive: true))
            return
        }
        
        // Obtém a URL do recurso do modelo
        guard let url = Bundle.module.url(forResource: modelname, withExtension: "usdz") else {
            fatalError("Model '\(modelname)' not found.")
        }

        // Carrega o modelo de forma assíncrona
        Entity.loadModelAsync(contentsOf: url)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    print("DEBUG - unable to load model entity for modelName: \(modelname). Error: \(error)")
                    completion(nil)
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                // Armazena o modelo carregado no cache
                self.models[intrumentName] = modelEntity
                self.models[intrumentName]?.name = intrumentName
                // Retorna um clone do modelo carregado
                completion(modelEntity.clone(recursive: true))
                print("DEBUG - successfully loaded model entity for modelName: \(modelname)")
            })
            .store(in: &cancellables)
    }
}


