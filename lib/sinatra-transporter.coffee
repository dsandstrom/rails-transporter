ViewFinderView = require './view-finder-view'
MigrationFinderView = require './migration-finder-view'
FileOpener = require './file-opener'

module.exports =
  config:
    viewFileExtension:
      type:        'array'
      description: 'This is the extension of the view files.'
      default:     ['html.erb', 'html.slim', 'html.haml']
      items: 
        type: 'string'
    controllerSpecType:
      type:        'string'
      description: 'This is the type of the controller spec. controllers, requests or features'
      default:     'controller'
      enum:        ['controller', 'requests', 'features', 'api', 'integration']

  activate: (state) ->
    atom.commands.add 'atom-workspace',
      'sinatra-transporter:open-view-finder': =>
        @createViewFinderView().toggle()
      'sinatra-transporter:open-migration-finder': =>
        @createMigrationFinderView().toggle()
      'sinatra-transporter:open-model': =>
        @createFileOpener().openModel()
      'sinatra-transporter:open-helper': =>
        @createFileOpener().openHelper()
      'sinatra-transporter:open-partial-template': =>
        @createFileOpener().openPartial()
      'sinatra-transporter:open-test': =>
        @createFileOpener().openTest()
      'sinatra-transporter:open-spec': =>
        @createFileOpener().openSpec()
      'sinatra-transporter:open-asset': =>
        @createFileOpener().openAsset()
      'sinatra-transporter:open-controller': =>
        @createFileOpener().openController()
      'sinatra-transporter:open-layout': =>
        @createFileOpener().openLayout()
      'sinatra-transporter:open-view': =>
        @createFileOpener().openView()
      'sinatra-transporter:open-factory': =>
        @createFileOpener().openFactory()

  deactivate: ->
    if @viewFinderView?
      @viewFinderView.destroy()
    if @migrationFinderView?
      @migrationFinderView.destroy()

  createFileOpener: ->
    unless @fileOpener?
      @fileOpener = new FileOpener()

    @fileOpener

  createViewFinderView: ->
    unless @viewFinderView?
      @viewFinderView = new ViewFinderView()

    @viewFinderView

  createMigrationFinderView: ->
    unless @migrationFinderView?
      @migrationFinderView = new MigrationFinderView()

    @migrationFinderView
