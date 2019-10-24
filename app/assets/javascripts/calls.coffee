# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  clicked = null

  spin = (a)->
    clicked = $(a)
    $('.fa-download', clicked).removeClass('fa-download').addClass('fa-circle-o-notch fa-spin')

  stop_spin = ->
    $('.fa-spin', clicked).removeClass('fa-circle-o-notch fa-spin').addClass('fa-download')
    clicked = null

  $( document ).on "click", ".download-call", ->
    return false if clicked
    spin(this)

  $( document ).on("ajax:success", '.download-call', ->
    [data, status, xhr] = event.detail
    stop_spin()

    if data && data.url
      document.location.href = data.url
    else
      alert("Ошибка: ссылка пустая")
  )

  $( document ).on("ajax:error", '.download-call', (event) ->
    stop_spin()
    alert("Ошибка при получении ссылки для скачивания")
  )
