jQuery ->
  $('#asset_file').attr('name', 'asset[file]')
  $('#new_asset').fileupload
    paramName: 'asset[file]'
    dataType: "script"
    limitConcurrentUploads: 2
    maxChunkSize: 20000000
    add: (e, data) ->
      data.context = $(tmpl("template-upload", data.files[0]))
      $('#new_asset').append(data.context)
      data.submit()
    done: (e, data) ->
      $.ajax(
        type: "POST"
        url: $("#new_asset").attr("action") + "/freeze.json"
        data: {filename: data.files[0].name}
        success: (result, textStatus, jqXHR) ->
          data.context.fadeOut('slow')
          $('#assets').append($(tmpl("template-done", result)))
        dataType: "json"
      )
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
