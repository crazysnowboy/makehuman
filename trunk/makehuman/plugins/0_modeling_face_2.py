#!/usr/bin/python
# -*- coding: utf-8 -*-
# We need this for gui controls

import gui3d
import humanmodifier

print 'Face imported'

class GroupBoxRadioButton(gui3d.RadioButton):
    def __init__(self, parent, group, label, groupBox, selected=False):
        gui3d.RadioButton.__init__(self, parent, group, label, selected, style=gui3d.ButtonStyle)
        self.groupBox = groupBox
        
    def onClicked(self, event):
        gui3d.RadioButton.onClicked(self, event)
        self.parent.parent.hideAllBoxes()
        self.groupBox.show()
        
class FaceSlider(humanmodifier.ModifierSlider):
    def __init__(self, parent, modifier, image, view):
        
        humanmodifier.ModifierSlider.__init__(self, parent, min=-1.0, max=1.0, modifier=modifier, style=gui3d.SliderStyle._replace(height=56, normal=image))
        
        self.view = getattr(self.app, view)
        
    def onFocus(self, event):
        
        humanmodifier.ModifierSlider.onFocus(self, event)
        self.view()

class FaceTaskView(gui3d.TaskView):

    def __init__(self, category):
        gui3d.TaskView.__init__(self, category, 'Face2')
        
        features = [
            ('eyes', [('data/targets/eyes/${ethnic}/${gender}_${age}/%s-${%s}.target' % (i[0], i[1]), i[0], i[1], i[2], i[3], 'data/targets/eyes/images/', i[4]) for i in
                [   
                    ('l-eye-height1', 'leyeheight1', 'min', 'max', 'frontView'),
                    ('l-eye-height2', 'leyeheight2', 'min', 'max', 'frontView'),
                    ('l-eye-height3', 'leyeheight3', 'min', 'max', 'frontView'),
                    ('l-eye-push', 'leyepush', 'in1', 'out1', 'frontView'),
                    ('l-eye-push', 'leyepush2', 'in2', 'out2', 'frontView'),
                    ('l-eye-move', 'leyemove', 'in', 'out', 'frontView'),
                    ('l-eye-move', 'leyemove2', 'up', 'down', 'frontView'),
                    ('l-eye', 'leye3', 'small', 'big', 'frontView'),
                    
                    ('r-eye-height1', 'reyeheight1', 'min', 'max', 'frontView'),
                    ('r-eye-height2', 'reyeheight2', 'min', 'max', 'frontView'),
                    ('r-eye-height3', 'reyeheight3', 'min', 'max', 'frontView'),
                    ('r-eye-push', 'reyepush', 'in1', 'out1', 'frontView'),
                    ('r-eye-push', 'reyepush2', 'in2', 'out2', 'frontView'),
                    ('r-eye-move', 'reyemove', 'in', 'out', 'frontView'),
                    ('r-eye-move', 'reyemove2', 'up', 'down', 'frontView'),
                    ('r-eye', 'reye3', 'small', 'big', 'frontView')
                ]]),
            ('nose', [('data/targets/nose/${ethnic}/${gender}_${age}/%s-${%s}.target' % (i[0], i[1]), i[0], i[1], i[2], i[3], 'data/targets/nose/images/', i[4]) for i in
                [   
                    ('nose', 'nose', 'compress', 'uncompress', 'rightView'),
                    ('nose', 'nose', 'convex', 'concave', 'rightView'),
                    ('nose', 'nose', 'greek', 'ungreek', 'rightView'),
                    ('nose-height', 'noseheight', 'min', 'max', 'rightView'),
                    ('nose', 'nose', 'hump', 'unhump', 'rightView'),
                    ('nose', 'nose', 'potato', 'point', 'rightView'),
                    ('nose', 'nose', 'long', 'short', 'rightView'),
                    ('nose-nostrils', 'nosenostrils', 'point', 'unpoint', 'frontView'),
                    ('nose-nostrils', 'nosenostrils', 'up', 'down', 'rightView'),
                    ('nose-nostril-width', 'nosenostrilwidth', 'min', 'max', 'frontView'),
                    ('nose-point', 'nosepoint', 'up', 'down', 'rightView'),
                    ('nose-width1', 'nosewidth1', 'min', 'max', 'frontView'),
                    ('nose-width2', 'nosewidth2', 'min', 'max', 'frontView'),
                    ('nose-width3', 'nosewidth3', 'min', 'max', 'frontView'),
                    ('nose-width', 'nosewidth', 'min', 'max', 'frontView')
                ]])    
            ]

        y = 80
        
        self.groupBoxes = []
        self.radioButtons = []
        self.sliders = []
        
        self.modifiers = {}
        
        self.categoryBox = gui3d.GroupBox(self, [650, y, 9.0], 'Category', gui3d.GroupBoxStyle._replace(height=25+24*sum([(len(templates[1])/10 + (len(templates[1])%10>0)) for templates in features])+6))
        y += 25
        
        for name, templates in features:
            
            for index, template in enumerate(templates):
                
                if index % 6 == 0:
                    
                    if len(templates) <= 6:
                        title = name.capitalize()
                    else:
                        title = '%s %d' % (name.capitalize(), index / 6 + 1)
                        
                    # Create box
                    box = gui3d.GroupBox(self, [10, 80, 9.0], title, gui3d.GroupBoxStyle._replace(height=25+36*min(len(templates)-index, 10)+6))
                    self.groupBoxes.append(box)
                    
                    # Create radiobutton
                    radio = GroupBoxRadioButton(self.categoryBox, self.radioButtons, title, box, selected=len(self.radioButtons) == 0)
                    y += 24
            
                # Create sliders
                modifier = humanmodifier.GenderAgeEthnicAsymmetricModifier(template[0], template[2], template[3], template[4], False)
                self.modifiers['%s%d' % (name, index + 1)] = modifier
                slider = FaceSlider(box, modifier, '%s%s-%s-%s.png' % (template[5], template[1], template[3], template[4]), template[6])
                self.sliders.append(slider)
                
        y += 16

        self.hideAllBoxes()
        self.groupBoxes[0].show()
        
    def hideAllBoxes(self):
        
        for box in self.groupBoxes:
            
            box.hide()
    
    def onShow(self, event):

        gui3d.TaskView.onShow(self, event)
        
        self.app.setFaceCamera()
        
        for slider in self.sliders:
            slider.update()
            
    def onResized(self, event):
        
        self.categoryBox.setPosition([event.width - 150, self.categoryBox.getPosition()[1], 9.0])
        
    '''
    def onHumanChanged(self, event):
        
        human = event.human
        
        for slider in self.sliders:
            value = slider.modifier.getValue(human)
            if value:
                slider.modifier.setValue(human, value)
                
    def loadHandler(self, human, values):
        
        if values[0] == 'face':
            modifier = self.modifiers.get(values[1], None)
            if modifier:
                modifier.setValue(human, float(values[2]))
        elif values[0] == 'headAge':
            self.headAgeModifier.setValue(human, float(values[1]))
        elif values[0] == 'faceAngle':
            self.faceAngleModifier.setValue(human, float(values[1]))
       
    def saveHandler(self, human, file):
        
        for name, modifier in self.modifiers.iteritems():
            value = modifier.getValue(human)
            if value:
                file.write('face %s %f\n' % (name, value))
        
        file.write('headAge %f\n' % self.headAgeModifier.getValue(human))
        file.write('faceAngle %f\n' % self.faceAngleModifier.getValue(human))
    '''
    
def load(app):
    category = app.getCategory('Modelling')
    taskview = FaceTaskView(category)
    
    '''
    app.addLoadHandler('face', taskview.loadHandler)
    app.addLoadHandler('headAge', taskview.loadHandler)
    app.addLoadHandler('faceAngle', taskview.loadHandler)

    app.addSaveHandler(taskview.saveHandler)
    '''
    print 'Face loaded'

def unload(app):
    pass

