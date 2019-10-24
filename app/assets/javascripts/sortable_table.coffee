active_th = ->
  $('.dataTable th').click ->
    document.location.href = $(this).data('link')

  $('li.disabled.paginate_button').click ->
    return false



load_page = ->
  # $('.dataTable th').click (event) ->
  #   event.stopPropagation()
  #   $('a', $(this)).click()

  $('.paginate_button a, .dataTable th a').on("ajax:success", (event) ->
    [data, status, xhr] = event.detail
    window.last_event = event
    window.last_data = data

    $(".dataTables_wrapper:visible").replaceWith(xhr.responseText)
    load_page()
    # active_th()
  ).on("ajax:error", (event) ->
  )


$ ->
  load_page()
  # active_th()
