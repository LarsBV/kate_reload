## The headers should match the library you link against
# KATE_HEADERS = ./kate_headers
KATE_HEADERS = /usr/include/kate 


## The rest shouldn't bee necessary to edit, unless you need to use other kio / python / qt4 headers also.

TARGET      = Document
TARGET_FILE = $(TARGET).so
BUILD_DIR   = build
LIB_DIR     = ./Kate

## Binaries
CC          = c++
SIP_FILE    = sip/katedocument.sip
SIP_NAME    = Document
SIP_OPT     = -t ALL -t WS_X11 -t Qt_4_8_4 -x VendorID -x PyQt_NoPrintRangeBug -P -g -x PyKDE_QVector -j 8 \
	      -c $(BUILD_DIR) \
	      -I /usr/share/sip/PyQt4 \
	      -I $(KATE_HEADERS)/part/ \
	      -I /usr/share/sip/PyKDE4 
	  
CC_D        = -DQT_CORE_LIB -DQT_GUI_LIB -DSIP_PROTECTED_IS_PUBLIC -DUSING_SOPRANO_NRLMODEL_UNSTABLE_API -D_BSD_SOURCE -D_REENTRANT -Dprotected=public -Dpython_module_PyKDE4_okular_EXPORTS 

CC_OPT      = -fPIC  -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith \
	      -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common -Woverloaded-virtual \
	      -fno-threadsafe-statics -fvisibility=default -Werror=return-type -fvisibility-inlines-hidden -O2 -g \
	      -DNDEBUG -DQT_NO_DEBUG -Wl,--enable-new-dtags -Wl,--fatal-warnings -Wl,--no-undefined \
	      -Wl,-rpath,~/kde/usr/lib/kde4 -lc -shared \
	      -Wl,--version-script=exportmap \
	      -Wl,-soname,$(TARGET_FILE) \
	      -lokularcore \
	      -lpython3.3m \
	      -lkdecore \
	      -lpthread \
	      -lQtCore \
	      -lkparts \
	      -lkdeui \
	      -lkatepartinterfaces \
	      -lktexteditor \
	      -I $(KATE_HEADERS)/part/ \
	      -I $(KATE_HEADERS)/part/buffer/ \
	      -I /usr/include/python3.3m/ \
	      -I /usr/include/qt4/QtCore/ \
	      -I /usr/include/qt4/Qt/ \
	      -I /usr/include/qt4/ \
	      -I /usr/include/kio/
				
$(TARGET): $(BUILD_DIR)/sipAPI$(SIP_NAME).h
	   $(CC) $(CC_D) $(CC_OPT) \
	   $(BUILD_DIR)/sip*.cpp \
	   -o build/$(TARGET_FILE)
	   
	   # move files
	   mkdir -p $(LIB_DIR)
	   cp build/$(TARGET_FILE) $(LIB_DIR)/
	   # strip
	   strip $(LIB_DIR)/$(TARGET_FILE)
	   # create __init__.py
	   echo -e "# This is needed to ensure that dynamic_cast and RTTI works."\
	           "\nimport sys,DLFCN"\
	           "\nsys.setdlopenflags(DLFCN.RTLD_NOW|DLFCN.RTLD_GLOBAL)" > $(LIB_DIR)/__init__.py
	
$(BUILD_DIR)/sipAPI$(SIP_NAME).h : $(SIP_FILE)
	   mkdir -p $(BUILD_DIR)
	   /usr/bin/sip $(SIP_OPT) $(SIP_FILE)

install: $(TARGET)
	ln -s $(pwd) ~/.kde4/share/apps/kate/pate/okular_plugin
	ln -s $(pwd)/katepate_okular_plugin.desktop ~/.kde4/share/kde4/services/

clean:
	rm -rf $(BUILD_DIR) $(LIB_DIR) __pycache__


	
.PHONY: $(TARGET) clean sip install
