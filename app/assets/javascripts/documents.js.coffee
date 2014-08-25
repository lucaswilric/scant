# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

addClickHandler = (cssClass) ->
  fileTypeHandler = () ->
    $('.'+cssClass+' input').attr('value', $(this).attr('id'))
  
  loadHandler = () ->
    $('.'+cssClass+' button').on('click', fileTypeHandler)
    $('.'+cssClass+' input').attr('value', $('.'+cssClass+' button.active').attr('id'))
  
  $(document).ready(loadHandler)

addClickHandler('file-type')
addClickHandler('scan-quality')