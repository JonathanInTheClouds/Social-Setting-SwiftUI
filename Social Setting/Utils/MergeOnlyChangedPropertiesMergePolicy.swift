//
//  MergeOnlyChangedPropertiesMergePolicy.swift
//  Social Setting
//
//  Created by Mettaworldj on 12/12/22.
//
import CoreData

class MergeOnlyChangedPropertiesMergePolicy: NSMergePolicy {
    
    public init() {
        super.init(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }
    
    override func resolve(constraintConflicts list: [NSConstraintConflict]) throws {
        try list.forEach { conflict in
            guard let databaseObject = conflict.databaseObject else {
                try super.resolve(constraintConflicts: list)
                return
            }
            let allRelationshipKeys = Set(databaseObject.entity.relationshipsByName.keys)
            
            conflict.conflictingObjects.forEach { conflictObject in
                let changedKeys = Set(conflictObject.changedValues().keys)
                restoreUnchangedRelationship(
                    allRelationhipKeys: allRelationshipKeys,
                    changedKeys: changedKeys,
                    databaseObject: databaseObject,
                    conflictObject: conflictObject
                )
            }
        }
        try super.resolve(constraintConflicts: list)
    }
    
    fileprivate func restoreUnchangedRelationship(
        allRelationhipKeys: Set<String>,
        changedKeys: Set<String>,
        databaseObject: NSManagedObject,
        conflictObject: NSManagedObject
    ) {
        let unchangedKeys = allRelationhipKeys.filter { !changedKeys.contains($0) }
        
        unchangedKeys.forEach { key in
            let value = databaseObject.value(forKey: key)
            conflictObject.setValue(value, forKey: key)
            databaseObject.setValue(nil, forKey: key)
        }
    }
}
