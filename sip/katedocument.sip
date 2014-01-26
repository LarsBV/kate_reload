%Module Kate.Document

%Import ktexteditor/ktexteditormod.sip    
%Import QtCore/QtCoremod.sip
%Import QtGui/QtGuimod.sip


class KateDocument : KTextEditor::Document
{
%TypeHeaderCode
#include <document/katedocument.h>
%End
public:
	void setModifiedOnDiskWarning(bool);
};


