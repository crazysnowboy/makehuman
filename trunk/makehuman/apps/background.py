#!/usr/bin/python
# -*- coding: utf-8 -*-

""" 
**Project Name:**      MakeHuman

**Product Home Page:** http://www.makehuman.org/

**Code Home Page:**    http://code.google.com/p/makehuman/

**Authors:**           Marc Flerackers

**Copyright(c):**      MakeHuman Team 2001-2010

**Licensing:**         GPL3 (see also http://sites.google.com/site/makehumandocs/licensing)

**Coding Standards:**  See http://sites.google.com/site/makehumandocs/developers-guide

Abstract
--------

TO DO

"""

__docformat__ = 'restructuredtext'

import gui3d
import events3d
import mh


class BackgroundTaskView(gui3d.TaskView):

    def __init__(self, category):
        gui3d.TaskView.__init__(self, category, 'Background')
        self.filechooser = gui3d.FileChooser(self, 'backgrounds', ['bmp', 'png', 'tif', 'tiff', 'jpg', 'jpeg'], None)
        self.texture = mh.Texture()

        @self.filechooser.event
        def onFileSelected(filename):
            print 'Loading %s' % filename
            self.texture.loadImage('backgrounds/' + filename)

      # self.app.categories["Modelling"].tasksByName["Macro modelling"].backgroundImageChooser.setTexture("backgrounds/" + filename)

            bg = self.app.categories['Modelling'].backgroundImage
            bg.mesh.setTexture('backgrounds/' + filename)
            group = bg.mesh.getFaceGroup('rectangle')
            group.setColor([255, 255, 255, 100])
            if self.texture.width > self.texture.height:
                bg.setScale(1.0, float(self.texture.height) / float(self.texture.width))
            else:
                bg.setScale(float(self.texture.width) / float(self.texture.height), 1.0)
            bg.mesh.setPickable(0)
            bg.show()
            self.app.categories['Modelling'].backgroundImageToggle.setSelected(True)
            self.app.switchCategory('Modelling')
            self.app.redraw()

    def onShow(self, event):

        # When the task gets shown, set the focus to the file chooser
        gui3d.TaskView.onShow(self, event)
        self.app.selectedHuman.hide()
        self.filechooser.setFocus()

    def onHide(self, event):
        self.app.selectedHuman.show()
        gui3d.TaskView.onHide(self, event)


