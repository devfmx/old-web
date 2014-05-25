appQuestion = ->
  $this = $(this).hide()
  container = $("<div>", {class: "ace-container", width: '800px', height: '400px'})
  $this.parent().append(container)
  editor = ace.edit(container.get(0))
  editor.setTheme('ace/theme/github')
  editor.getSession().setMode('ace/mode/yaml')
  editor.getSession().setValue($this.val())
  $($this.get(0).form).on 'submit', ->
    $this.val(editor.getValue())

jQuery ->
  $('textarea#batch_application_questions').each(appQuestion)
