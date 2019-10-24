# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window.ServiceAdded = (service_id, service_name)->
  selector = '.service-id-input[value="' + service_id + '"]'

  if $(selector).length > 0
    return

  window.next_num = window.next_num || $('.service-row').length

  template = $('#new-service-row')
  new_row = template.clone()
  new_row.removeAttr('id')

  $('.service-name', new_row).html(service_name)
  $('.service-id-input', new_row).attr('value', service_id)
  $('.service-num', new_row).html(window.next_num)


  new_row.insertBefore(template)
  new_row.show()

  $('input', new_row).each ->
    $(this).removeAttr('disabled')
    prev_name = $(this).attr('name')
    $(this).attr('name', prev_name.replace(/\[corp_pack_services_attributes\]\[\d+\]/, "[corp_pack_services_attributes][" + String(window.next_num) + "]"))

  window.next_num += 1
  $('a.remove-service', new_row).click -> new_row.remove()

$ ->
  if window.opener
    opener_doc = $(window.opener.document)

    $('span.add-service').each ->
      service_id = $(this).data('service-id')

      if opener_doc.find('.service-id-input[value="' + service_id + '"]').length > 0
        $(this).hide()

    $('.user-submit-btn').click ->
      return false

$ ->
  $('#new-service-row').hide()
  $('#new-service-row input').attr('disabled', 'disabled')

  $('#add_service_btn').click ->
    url      = $(this).data('url')
    novoForm = window.open(url, "", "width=800,height=600,location=no,menubar=no,status=no,titilebar=no,resizable=no,");
    return false

  $('.add-service').click ->
    # $(this).attr('style', 'color:green;')

    window.opener.ServiceAdded($(this).data('service-id'), $(this).data('service-name'))
    $(this).hide()

  $('#create-player-btn').click ->
    url      = $(this).data('url')
    novoForm = window.open(url, "", "width=800,height=600,location=no,menubar=no,status=no,titilebar=no,resizable=no,");
    return false

  $('#find-player-by-phone').click ->
    phone = $('#player-phone').val()

    $.get('/players/by_phone', {phone: phone}, (response)->
      if response['id']
        window.UserChosen(response['id'], response['name'])
      else
        alert("Игрок не найден")
    )
    
    return false


  $('#new-player-form').on("ajax:success", (event) ->
    [data, status, xhr] = event.detail

    if "object" == typeof data # responed with json
      window.opener.UserCreated(data["id"], data["name"])
      window.close()
    else
      $('#new-player-form').replaceWith(data)
      $(document).scrollTop( $('section').offset().top );

  ).on("ajax:error", (event) ->
    alert("error")
  )

  $('#corp_pack_player_id').click ->
    novoForm = window.open("/players?popup=1", "", "width=1200,height=600,location=no,menubar=no,status=no,titilebar=no,resizable=no,");
    return false


  if ($('.pagination-link-active').length > 0)
    $(document).scrollTop( $('.dataTable').offset().top );


  $('.choose-player').click ->
    name = $(this).data('player-name')
    id   = $(this).data('player-id')
    window.opener.UserChosen(id, name)

    window.close()

window.UserChosen = (id, name) ->
  sel = $("select#corp_pack_player_id")
  sel.html("<option value='#{id}' selected=selected>#{name}</option>")

window.UserCreated = (id, name) ->
  window.UserChosen(id, name)
  # sel = $("select#corp_pack_player_id")
  # $("option", sel).removeAttr("selected")
  # sel.prepend("<option value='#{id}' selected=selected>#{name}</option>")
