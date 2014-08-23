# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

fileTypeHandler = () ->
  $('.file-type input').attr('value', $(this).attr('id'))

loadHandler = () ->
  $('.file-type button').on('click', fileTypeHandler)
  $('.file-type input').attr('value', $('.file-type button.active').attr('id'))

$(document).ready(loadHandler)