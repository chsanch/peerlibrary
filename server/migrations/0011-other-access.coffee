class Migration extends Document.MinorMigration
  name: "Adding access, readPersons, readGroups fields"

  forward: (db, collectionName, currentSchema, newSchema, callback) =>
    db.collection collectionName, (error, collection) =>
      return callback error if error
      collection.update {_schema: currentSchema, access: {$exists: false}, readPersons: {$exists: false}, readGroups: {$exists: false}}, {$set: {access: ACCESS.PUBLIC, readPersons: [], readGroups: []}}, {multi: true}, (error, count) =>
        return callback error if error
        super db, collectionName, currentSchema, newSchema, callback

  backward: (db, collectionName, currentSchema, oldSchema, callback) =>
    db.collection collectionName, (error, collection) =>
      return callback error if error
      collection.update {_schema: currentSchema}, {$unset: {access: '', readPersons: '', readGroups: ''}}, {multi: true}, (error, count) =>
        return callback error if error
        super db, collectionName, currentSchema, oldSchema, callback

Annotation.addMigration new Migration()
Highlight.addMigration new Migration()
