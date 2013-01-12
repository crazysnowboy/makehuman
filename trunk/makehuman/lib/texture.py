#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
**Project Name:**      MakeHuman

**Product Home Page:** http://www.makehuman.org/

**Code Home Page:**    http://code.google.com/p/makehuman/

**Authors:**           Glynn Clements

**Copyright(c):**      MakeHuman Team 2001-2013

**Licensing:**         AGPL3 (see also http://www.makehuman.org/node/318)

**Coding Standards:**  See http://www.makehuman.org/node/165

Abstract
--------

TODO
"""

from OpenGL.GL import *
from OpenGL.GLU import *
from OpenGL.GL.ARB.texture_non_power_of_two import *
from core import G
from image import Image

class Texture(object):
    def __new__(cls, *args, **kwargs):
        self = super(Texture, cls).__new__(cls)

        self.textureId = glGenTextures(1)
        self.width = 0
        self.height = 0

        return self

    def __init__(self, image = None, size = None, components = 4):
        if image is not None:
            self.loadImage(image)
        elif size is not None:
            width, height = size
            self.initTexture(width, height, components)

    def __del__(self):
        try:
            glDeleteTextures(self.textureId)
        except StandardError:
            pass

    @staticmethod
    def getFormat(components):
        if components == 1:
            return (GL_ALPHA8, GL_ALPHA)
        elif components == 3:
            return (3, GL_RGB)
        elif components == 4:
            return (4, GL_RGBA)
        else:
            raise RuntimeError("Unsupported pixel format")

    def initTexture(self, width, height, components = 4, pixels = None):
        mipmaps = not glInitTextureNonPowerOfTwoARB()

        internalFormat, format = self.getFormat(components)

        glPixelStorei(GL_UNPACK_ALIGNMENT, 1)

        if height == 0:
            glBindTexture(GL_TEXTURE_1D, self.textureId)
            glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
            glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
            if mipmaps:
                glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
            else:
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
            glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

            if mipmaps:
                gluBuild1DMipmaps(GL_TEXTURE_1D, internalFormat, width, format, GL_UNSIGNED_BYTE, pixels)
            else:
                glTexImage1D(GL_TEXTURE_1D, 0, internalFormat, width, 0, format, GL_UNSIGNED_BYTE, pixels)
            glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
        else:
            glBindTexture(GL_TEXTURE_2D, self.textureId)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
            if mipmaps:
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
            else:
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

            if mipmaps:
                gluBuild2DMipmaps(GL_TEXTURE_2D, internalFormat, width, height, format, GL_UNSIGNED_BYTE, pixels)
            else:
                glTexImage2D(GL_TEXTURE_2D, 0, internalFormat, width, height, 0, format, GL_UNSIGNED_BYTE, pixels)
            glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)

        self.width, self.height = width, height

    def loadImage(self, image):
        if isinstance(image, (str, unicode)):
            image = Image(image)

        pixels = image.flip_vertical().data

        self.initTexture(image.width, image.height, image.components, pixels)

    def loadSubImage(self, image, x, y):
        if not self.textureId:
            raise RuntimeError("Texture is empty, cannot load a sub texture into it")

        if isinstance(image, (str, unicode)):
            image = Image(image)

        internalFormat, format = self.getFormat(components)

        pixels = image.flip_vertical().data

        if image.height == 0:
            glBindTexture(GL_TEXTURE_1D, self.textureId)
            glTexSubImage1D(GL_TEXTURE_1D, 0, x, image.width, format, GL_UNSIGNED_BYTE, pixels)
        else:
            glBindTexture(GL_TEXTURE_2D, self.textureId)
            glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, image.width, image.height, format, GL_UNSIGNED_BYTE, pixels)
