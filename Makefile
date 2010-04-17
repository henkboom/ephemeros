NAME=ephemeros
APPNAME=Ephemeros

PLATFORMS=linux macosx mingw

$(PLATFORMS) clean:
	make -C dokidoki-support $@ NAME="../$(NAME)"

$(APPNAME).app: macosx Info.plist
	rm -rf $@
	mkdir -p $@
	mkdir -p $@/Contents
	mkdir -p $@/Contents/MacOS
	mkdir -p $@/Contents/Resources
	mkdir -p $@/Contents/Frameworks
	cp Info.plist $@/Contents/
	cp $(NAME) $@/Contents/MacOS/$(APPNAME)
	# dokidoki
	cp -r dokidoki $@/Contents/Resources/dokidoki
	# socket
	cp socket.so mime.so $@/Contents/Resources/
	cp -r socket $@/Contents/Resources/socket
	# lua files
	cp *.lua $@/Contents/Resources
	mkdir -p $@/Contents/Resources/components
	cp components/*.lua $@/Contents/Resources/components
	mkdir -p $@/Contents/Resources/scripts
	cp scripts/*.lua $@/Contents/Resources/scripts
	mkdir -p $@/Contents/Resources/levels
	cp levels/*.lua $@/Contents/Resources/levels
	# resources
	mkdir -p $@/Contents/Resources/sprites
	cp sprites/*.png $@/Contents/Resources/sprites
	# dylibs
	cp /usr/local/lib/libportaudio.dylib $@/Contents/Frameworks/

