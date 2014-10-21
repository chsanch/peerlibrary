class @NormalizePublicationJob extends Job
  enqueueOptions: (options) =>
    options = super

    _.defaults options,
      priority: 'mdeium'

  run: =>
    publication = @data.publication

    Future = Npm.require 'fibers/future'
    child_process = Npm.require 'child_process'

    if Meteor.settings.ghostScript
      path = Storage._fullPath(publication.cachedFilename()).split Storage._path.sep
      path.pop()
      path = path.join Storage._path.sep

      execCmd = (cmd, opts) ->
        future = new Future()

        child_process.exec cmd, opts, (error, stdout, stderr) ->
          future.return
            success: not error
            stdout: stdout
            stderr: stderr

        future.wait()

      result = execCmd "gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dFastWebView=true -sOutputFile=" + path + "/2.pdf " + Storage._fullPath publication.cachedFilename()

      pdf = Storage.open publication.cachedFilename(2)

      hash = new Crypto.SHA256()
      hash.update pdf
      sha256 = hash.finalize()

      publication.files.push
        fileID: Random.id()
        createdAt: moment.utc().toDate()
        updatedAt: moment.utc().toDate()
        sha256: sha256
        mediaType: 'pdf'
        type: 'normalized-gs'

    return # Return nothing

Job.addJobClass NormalizePublicationJob
