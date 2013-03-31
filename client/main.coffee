do -> # To not pollute the namespace
  Meteor.Router.add
    '/': ->
      Session.set 'time', 123
      'index'
    '/login': 'login'
    '/logout': ->
      Meteor.logout()
      'hello'
    '/register': 'register'
    '/p/:publicationId': (publicationId) ->
      Session.set 'currentPublicationId', publicationId
      'publication'
    '/u/:username': (username) ->
      Session.set 'currentProfileUsername', username
      'profile'
    '/search': ->
      Session.set 'currentSearchQuery', parseQuery this.querystring
      'results'

  # TODO: Use real parser (arguments can be listed multiple times, arguments can be delimited by ";")
  parseQuery = (qs) ->
    query = {}
    for pair in qs.replace('?', '').split '&'
      [k, v] = pair.split('=')
      query[k] = v
    query