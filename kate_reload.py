# -*- coding: utf-8 -*-

# Author: Lars Banner-Voigt
# License see LICENSE

# Reference docs
#    http://api.kde.org/4.11-api/applications-apidocs/kate/kate/interfaces/kate/html/index.html
#    http://patches.fedorapeople.org/pate-docs/_modules/kate/__init__.html#action

from PyKDE4.kdecore import i18n
from PyKDE4.kdeui import KAction, KIcon

from PyQt4.QtCore import QObject
from PyQt4.QtGui import QMenu

from libkatepate.errors import showOk, showError

import kate

# My own c++ wrapper, to KateDocument.setModifiedOnDiskWarning 
from .Kate.Document import KateDocument
import sip



class KateReload(QObject):
  def __init__(self):
    QObject.__init__(self)
    
    self.window = kate.mainInterfaceWindow().window()
    
    kate.configuration.root.clear()
    
    self.act = KAction(KIcon("reload"), i18n("Auto Reload"), self)
    self.act.setObjectName("auto reload")
        
    self.window.actionCollection().addAction(self.act.objectName(), self.act)    
    self.window.findChild(QMenu, 'view').addAction(self.act)

    if not self.act.objectName() in kate.configuration:
        kate.configuration[self.act.objectName()] = "alt+r"
    self.act.setShortcut(kate.configuration[self.act.objectName()])

    self.act.setCheckable(True)
    self.act.setChecked(False)

    
    self.act.changed.connect(self.onActionChange)
    self.act.toggled.connect(self.toggle)
    
    kate.mainInterfaceWindow().viewChanged.connect(self.onViewChanged)
        
  def onViewChanged(self):
      try:
        doc = sip.cast(kate.activeDocument(), KateDocument)
      except kate.api.NoActiveView:
        return
    
      self.act.blockSignals(True)
      if doc.property('AutoReload'):
          self.act.setChecked(True)
      else:
          self.act.setChecked(False)
      self.act.blockSignals(False)
      

  def onActionChange(self):
      kate.configuration[self.sender().objectName()] = self.sender().shortcut().toString()
      kate.configuration.save()
  
  def toggle(self, state):
      doc = sip.cast(kate.activeDocument(), KateDocument)
      if state == True:
        self.enable(doc)
      else:
        self.disable(doc)
  
  def enable(self, doc):
      if doc.url() == '':
        self.act.blockSignals(True)
        showError(i18n('Can\'t auto-reload unsaved file'))
        self.act.setChecked(False)
        self.act.blockSignals(False)
        return

      doc.setModifiedOnDiskWarning(False)
      doc.modifiedOnDisk.connect(doc.documentReload)
      doc.setProperty('AutoReload', True)
      
      showOk(i18n('Auto-Reload enabled'))
      
  def disable(self, doc):
      if doc.property('AutoReload'):
        doc.setModifiedOnDiskWarning(True)
        doc.modifiedOnDisk.disconnect(doc.documentReload)
        doc.setProperty('AutoReload', False)
        showOk(i18n('Auto-Reload disabled'))
      else:
        print('Error disabled called on something with no auto-reload')
      
      
      
      
      
      
      
      
      
      