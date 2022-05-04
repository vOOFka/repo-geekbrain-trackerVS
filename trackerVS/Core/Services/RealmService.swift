//
//  RealmService.swift
//  vkontakteVS
//
//  Created by Home on 13.09.2021.
//

import RealmSwift

protocol RealmService {
    func get<T: Object, KeyType> (_ type: T.Type, primaryKey: KeyType) throws -> T?
    func get<T: Object> (_ type: T.Type) throws -> Results<T>
    func update<T: Object>(_ items: [T]) throws -> Realm
    func update<T: Object>(_ item: T) throws -> Realm
    func objectExists<T: Object> (_ type: T.Type, id: Int) throws -> Bool
    func update<T: Object, KeyType> (_ item: T, primaryKey: KeyType) throws -> Realm
    func delete<T: Object> (_ item: T) throws
}

final class RealmServiceImplimentation: RealmService {
    //Update or save some objects in Realm DB
    func update<T: Object>(_ items: [T]) throws -> Realm {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try Realm(configuration: config)
        realm.beginWrite()
        realm.add(items, update: .modified)
      //  realm.add(itemsToSave)
        try realm.commitWrite()
        return realm
    }
    //Update some object in Realm DB
    func update<T: Object>(_ item: T) throws -> Realm {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try Realm(configuration: config)
        realm.beginWrite()
        realm.add(item, update: .modified)
        try realm.commitWrite()
        return realm
    }
    //update some object from Realm DB
    func update<T: Object, KeyType> (_ item: T, primaryKey: KeyType) throws -> Realm {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try Realm(configuration: config)
        realm.beginWrite()
        realm.add(item, update: .modified)
        try realm.commitWrite()
        return realm
    }
    //Get some object from Realm DB
    func get<T: Object, KeyType> (_ type: T.Type, primaryKey: KeyType) throws -> T? {
        let realm = try Realm()
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    //Get some objects from Realm DB
    func get<T: Object> (_ type: T.Type) throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(type)
    }
    func objectExists<T: Object> (_ type: T.Type, id: Int) throws -> Bool {
        let realm = try Realm()
        return realm.object(ofType: T.self, forPrimaryKey: id) != nil
    }
    //Delete some object from Realm DB
    func delete<T: Object> (_ item: T) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(item)
        }
    }
}
