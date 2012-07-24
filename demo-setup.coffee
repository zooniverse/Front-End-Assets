define (require, exports, module) ->
  zooniverse = require 'zooniverse/index'

  window.seafloorExplorer = new zooniverse.Workflow
    name: 'Seafloor Explorer'
    domain: 'seafloorexplorer.org'
    project: 'sea_floor'
    id: '4fa408de54558f3d6a000002'

  class Classifier extends zooniverse.Classifier
    template: '''
      <div class="classification">
        <img />
        <button class="minus">-</button>
        <span class="value"></span>
        <button class="plus">+</button>
        <div><button class="done">Done &rarr;</button></div>
      </div>

      <div class="summary">
        <div class="favorite">
          <button class="create-favorite">&hearts; Favorite</button>
          <button class="destroy-favorite">Undo favorite</button>
        </div>
        <button class="talk">Go to talk</button>
        <button class="continue">Continue</button>
      </div>
    '''

    @element 'img', 'image'

    @element '.value', 'valueContainer'

    @delegate 'click! .minus', ->
      @annotation.set total: @annotation.get('total') - 1

    @delegate 'click! .plus', ->
      @annotation.set total: @annotation.get('total') + 1

    @delegate 'click! .done', 'saveClassification'

    @delegate 'click! .create-favorite', 'createFavorite'

    @delegate 'click! .destroy-favorite', 'destroyFavorite'

    @delegate 'click! .talk', 'goToTalk'

    @delegate 'click! .continue', 'nextSubjects'

    selectionChanged: =>
      super
      @annotation = @classification.annotate total: 0
      @image.attr src: @workflow.selection[0].location.standard

    render: =>
      super
      @valueContainer.html @annotation.get 'total'

  window.classifier = new Classifier
    el: '#classifier'

  window.profile = new zooniverse.Profile
    el: '#profile'
