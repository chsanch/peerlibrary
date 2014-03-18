class @Annotation extends Annotation
  @Meta
    name: 'Annotation'
    replaceParent: true

  # A set of fields which are public and can be published to the client
  @PUBLIC_FIELDS: ->
    fields: {} # All

Annotation.Meta.collection.allow
  insert: (userId, doc) ->
    # TODO: Check whether inserted document conforms to schema
    # TODO: Check that author really has access to the publication
    return false unless userId

    personId = Meteor.personId userId

    # Only allow insertion if declared author is current user
    personId and doc.author._id is personId

  update: (userId, doc) ->
    return false unless userId

    personId = Meteor.personId userId

    # Only allow update if declared author is current user
    personId and doc.author._id is personId

  remove: (userId, doc) ->
    return false unless userId

    personId = Meteor.personId userId

    # Only allow removal if author is current user
    personId and doc.author._id is personId

# Misuse insert validation to add additional fields on the server before insertion
Annotation.Meta.collection.deny
  # We have to disable transformation so that we have
  # access to the document object which will be inserted
  transform: null

  insert: (userId, doc) ->
    doc.created = moment.utc().toDate()
    doc.updated = doc.created
    doc.references = {} if not doc.references

    # Convert list of tag names (strings) to tag subdocuments
    if doc.tags
      tags = _.map doc.tags, (name) ->
        existingTag = Tag.documents.findOne
          'name.en': name

        return _.pick(existingTag, '_id', 'name') if existingTag?

        annotationId = Tag.documents.insert
          name:
            en: name

        # return
        _id: annotationId
        name:
          en: name

      doc.tags = tags
    else
      doc.tags = []

    # We return false as we are not
    # checking anything, just adding fields
    false

  update: (userId, doc) ->
    doc.updated = moment.utc().toDate()

    # We return false as we are not
    # checking anything, just updating fields
    false

Meteor.publish 'annotations-by-id', (id) ->
  check id, String

  return unless id

  Annotation.documents.find
    _id: id
  ,
    Annotation.PUBLIC_FIELDS()

Meteor.publish 'annotations-by-publication', (publicationId) ->
  check publicationId, String

  return unless publicationId

  Annotation.documents.find
    'publication._id': publicationId
  ,
    Annotation.PUBLIC_FIELDS()
