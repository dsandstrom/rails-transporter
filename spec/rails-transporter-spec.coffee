path = require 'path'
fs = require 'fs'
temp = require 'temp'
wrench = require 'wrench'


{$, WorkspaceView} = require 'atom'
RailsTransporter = require '../lib/rails-transporter'

describe "RailsTransporter", ->
  activationPromise = null
  [viewFinderView, workspaceView] = []

  beforeEach ->
    # set Project Path to temporaly directory.
    tempPath = fs.realpathSync(temp.mkdirSync('atom'))
    fixturesPath = atom.project.getPath()
    wrench.copyDirSyncRecursive(fixturesPath, tempPath, forceDelete: true)
    atom.project.setPath(path.join(tempPath, 'rals-transporter'))

    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync(path.join(atom.project.getPath(), 'app/controllers/blogs_controller.rb'))
    atom.editorView = atom.workspaceView.getActiveView()
    atom.editor = atom.editorView.getEditor()

    activationPromise = atom.packages.activatePackage('rails-transporter')

  describe "view-finder behavior", ->
    describe "when the rails-transporter:toggle-view-finder event is triggered", ->
      it "shows the ViewFinder or hides it if it's already showing", ->
        expect(atom.workspaceView.find('.select-list')).not.toExist()
        
        # This is an activation event, triggering it will cause the package to be
        # activated.
        atom.workspaceView.trigger 'rails-transporter:toggle-view-finder'

        # Waits until package is activated
        waitsForPromise ->
          activationPromise

        runs ->
          expect(atom.workspaceView.find('.select-list')).toExist()
          atom.workspaceView.trigger 'rails-transporter:toggle-view-finder'
          expect(atom.workspaceView.find('.select-list')).not.toExist()

      it "shows all relative view paths for the current controller and selects the first", ->
        atom.workspaceView.trigger 'rails-transporter:toggle-view-finder'
      
        # Waits until package is activated
        waitsForPromise ->
          activationPromise

        runs ->
          viewDir = path.join(atom.project.getPath(), "app/views/blogs/")
          expect(atom.workspaceView.find('.select-list li').length).toBe fs.readdirSync(viewDir).length
          for view in fs.readdirSync(viewDir)
            expect(atom.workspaceView.find(".select-list .primary-line:contains(#{view})")).toExist()
            expect(atom.workspaceView.find(".select-list .secondary-line:contains(#{path.join(viewDir, view)})")).toExist()

          expect(atom.workspaceView.find(".select-list li:first")).toHaveClass 'two-lines selected'
