jQuery ->
  $('#asset_file').attr('name', 'asset[file]')
  $('#new_asset').fileupload
    paramName: 'asset[file]'
    dataType: "script"
    maxChunkSize: 20000000
    add: (e, data) ->
      $.each(data.files, (index, file) -> 
        $.post(
          $('#new_asset').attr('action') + '.json'
          {"filename": file.name}
          (postData, textStatus, jqXHR) ->
            data.url = $('#new_asset').attr('action') + '/' + postData.id + '/' + 'chunks'
            data.context = $(tmpl("template-upload", file))
            $('#new_asset').append(data.context)
        )
      )
      data.submit()
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
    chunksend: (e, data) ->
      console.log "chunksend"
