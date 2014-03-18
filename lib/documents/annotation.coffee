class @Annotation extends Document
  # created: timestamp when document was created
  # updated: timestamp of this version
  # author:
  #   _id: person id
  #   slug
  #   givenName
  #   familyName
  #   gravatarHash
  #   user
  #     username
  # body: annotation's body
  # publication:
  #   _id
  # references: made in the body
  #   highlights: list of
  #     _id
  #   annotations: list of
  #     _id
  #   publications: list of
  #     _id
  #     slug
  #     title
  #   persons: list of
  #     _id
  #     slug
  #     givenName
  #     familyName
  #   tags: list of
  #     _id
  #     name: ISO 639-1 dictionary
  #     slug: ISO 639-1 dictionary
  # tags: list of
  #   tag:
  #     _id
  #     name: ISO 639-1 dictionary
  #     slug: ISO 639-1 dictionary
  #   upvoters: list of
  #     _id: person id
  #   downvoters: list of
  #     _id: person id
  # upvoters: list of
  #   _id: person id
  # downvoters: list of
  #   _id: person id
  # local (client only): is this annotation just a temporary annotation on the client side

  @Meta
    name: 'Annotation'
    fields: =>
      author: @ReferenceField Person, ['slug', 'givenName', 'familyName', 'gravatarHash', 'user.username']
      publication: @ReferenceField Publication
      references:
        highlights: [@ReferenceField Highlight, [], true, 'referencingAnnotations']
        annotations: [@ReferenceField 'self', [], true, 'referencingAnnotations']
        publications: [@ReferenceField Publication, ['slug', 'title'], true, 'referencingAnnotations']
        persons: [@ReferenceField Person, ['slug', 'givenName', 'familyName'], true, 'referencingAnnotations']
        tags: [@ReferenceField Tag, ['name', 'slug'], true, 'referencingAnnotations']
      tags: [
        tag: @ReferenceField Tag, ['name', 'slug']

        # TODO: Field cannot be in a nested array (PeerDB)
        #upvoters: [@ReferenceField Person]
        #downvoters: [@ReferenceField Person]
      ]
