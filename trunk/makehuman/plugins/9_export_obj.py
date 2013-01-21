import gui
from export import Exporter

class ExporterOBJ(Exporter):
    def __init__(self):
        Exporter.__init__(self)
        self.name = "Wavefront obj"
        self.filter = "Wavefront (*.obj)"

    def build(self, options):
        self.exportEyebrows = options.addWidget(gui.CheckBox("Eyebrows", True))
        self.exportLashes   = options.addWidget(gui.CheckBox("Eyelashes", True))
        self.exportHelpers  = options.addWidget(gui.CheckBox("Helper geometry", False))
        self.exportHidden   = options.addWidget(gui.CheckBox("Keep hidden faces", True))
        self.exportSkeleton = options.addWidget(gui.CheckBox("Skeleton", True))
        self.exportSmooth   = options.addWidget(gui.CheckBox("Subdivide", False))
        self.objScales = self.addScales(options)

    def export(self, human, filename):
        import mh2obj_proxy, mh2bvh

        options = {
            "helpers" : self.exportHelpers.selected,
            "hidden" : self.exportHidden.selected,
            "eyebrows" : self.exportEyebrows.selected,
            "lashes" : self.exportLashes.selected,
            "scale": self.getScale(self.objScales),
            "subdivide": self.exportSmooth.selected
        }                    

        mh2obj_proxy.exportProxyObj(human, filename("obj"), options)

        if self.exportSkeleton.selected:
            mh2bvh.exportSkeleton(human.meshData, filename("bvh", True))

def load(app):
    app.addExporter(ExporterOBJ())

def unload(app):
    pass
