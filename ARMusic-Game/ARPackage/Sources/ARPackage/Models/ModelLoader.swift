//
//  InstrumentModel.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Combine
import Foundation
import UIKit
import AudioPackage

public class ModelLoader {
    private static var cancellables = Set<AnyCancellable>()
    private static var models: [String: Entity] = [:]
    
    public required init() {}
    
    public static func load(instrument: Instrument, instrumentSystem: InstrumentSystem, completion: @escaping (InstrumentEntity?) -> Void) {
        
        // Verifica se o modelo já está no cache
        if let model = models[instrument.name] {
            let instrumentEntity = InstrumentEntity(instrument: Instrument(
                name: instrument.name,
                modelName: instrument.modelName,
                notes: instrument.notes,
                sequence: instrument.sequence
            ))
            
            // Clona o modelo
            let modelClone = model.clone(recursive: true)
            instrumentEntity.addChild(modelClone)
            
            // Cria e configura os componentes
            var inputComponent = InputComponent()
            var audioComponent = AudioComponent(note: .d, instrument: .piano, tom: 123.0)
            audioComponent.tempo.toggleValue(at: 0)
            
            // Adiciona a função de gesto ao InputComponent
            inputComponent.addGestureFunc(gesture: UITapGestureRecognizer.self) { gesture in
                instrumentSystem.handleTapOnEntity(instrumentEntity)
                WorldSystem.editEntity(modelClone as! ModelEntity) // Use modelClone para manter a consistência
            }
            
            // Adiciona os componentes à entidade
            modelClone.components.set(audioComponent)
            modelClone.components.set(inputComponent)
            
            // Retorna a InstrumentEntity já configurada
            completion(instrumentEntity)
            
            print("DEBUG - successfully loaded model entity for modelName: \(instrument.modelName)")
            return
        }
        
        // Obtém a URL do recurso do modelo
        guard let url = Bundle.module.url(forResource: instrument.modelName, withExtension: "usdz") else {
            fatalError("Model '\(instrument.modelName)' not found.")
        }
        
        // Carrega o modelo de forma assíncrona
        Entity.loadModelAsync(contentsOf: url)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    print("DEBUG - unable to load model entity for modelName: \(instrument.modelName). Error: \(error)")
                    completion(nil)
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                // Armazena o modelo carregado no cache
                self.models[instrument.name] = modelEntity
                
                let instrumentEntity = InstrumentEntity(instrument: Instrument(
                    name: instrument.name,
                    modelName: instrument.modelName,
                    notes: instrument.notes,
                    sequence: instrument.sequence
                ))
                
                instrumentEntity.addChild(modelEntity)
                
                var inputComponent = InputComponent()
                var audioComponent = AudioComponent(note: .d, instrument: .piano, tom: 123.0)
                
                audioComponent.tempo.toggleValue(at: 0)
                
                inputComponent.addGestureFunc(gesture: UITapGestureRecognizer.self) { gesture in
                    instrumentSystem.handleTapOnEntity(instrumentEntity)
                    WorldSystem.editEntity(modelEntity)
                }
                
                modelEntity.components.set(audioComponent)
                modelEntity.components.set(inputComponent)
                
                // Retorna a InstrumentEntity já configurada
                completion(instrumentEntity)
                
                print("DEBUG - successfully loaded model entity for modelName: \(instrument.modelName)")
            })
            .store(in: &cancellables)
    }
}




