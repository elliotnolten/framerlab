# >>> Framer Fold >>>
# Sharing Info
# This info is presented in a widget when you share

Framer.Info =
	title: "The Garmentor Landing page version 2"
	description: ""
	author: "Elliot Nolten"
	twitter: "@elliotnolten"

# <<< Framer Fold <<<

# Globals, settings and wrappers
# Orientation module from https://github.com/joshmtucker/OrientationEvents
orient = require "OrientationEvents"

screenW = Screen.width
screenH = Screen.height
x = Utils.devicePixelRatio()

# Detect device type
isFullscreen = Framer.Device.deviceType.indexOf("fullscreen") != -1
isPhone = Framer.Device.deviceType.indexOf("iphone") != -1
isTablet = Framer.Device.deviceType.indexOf("ipad") != -1

if isPhone || isTablet then isRetina = true else isRetina = false
if isFullscreen
	if Utils.isPhone() || Utils.isTablet()
		isRetina = true
	else
		isRetina = false
		
if isRetina then x = 2 else x = 1

Utils.insertCSS("@import 'https://fonts.googleapis.com/css?family=Roboto+Condensed:400|Roboto:300,700';")

bg = new BackgroundLayer backgroundColor: "#f2f2f2"
Framer.Defaults.Animation =
	curve: "spring(200,20,10)"

site = new PageComponent
	width: screenW, height: screenH
site.scrollHorizontal = false
site.scrollVertical = false
site.mouseWheelEnabled = isFullscreen

# Sections
sections = [
	{
		title: ""
		content: "The Garmentor is a stylist from Suitsupply who helps you with your alterations."
		name: "intro"
		icon: ""
	}
	{
		title: "Find a Garmentor"
		content: "Our Garmentors are available nearby you and can be ordered with the Suitsupply app."
		name: "usp1"
	}
	{
		title: "Have it tailored"
		content: "Our on-demand Garmentor visits you at any location. He will check your suit, jacket or trousers for alterations."
		name: "usp2"
	}
	{
		title: "Get it delivered"
		content: "The fitting session, delivery and returns are free of charge. Pay only for your alterations.<br><br>Open the app and order a Garmentor."
		name: "usp3"
	}
]

verticalSections =
	top: { top: 0, bottom: 0.5 * screenH }
	middle: { top: 0.5 * screenH, bottom: 0.75 * screenH}
	bottom: {top: 0.75 * screenH, bottom: screenH}

verticalParts = new Layer width: screenW, height: screenH, backgroundColor: null
verticalParts.bringToFront()

for i,s of verticalSections
	section = new Layer width: verticalParts.width, height: s.bottom - s.top, y: s.top, backgroundColor: null
# 	section.style = "border-bottom": "#{x}px solid rgba(255,255,255,0.5)"

# Skyline
city = new Layer width: screenW, height: screenH, backgroundColor: null, parent: site.content

sky = new Layer
	parent: city
	width: screenW * sections.length * 0.5, height: screenH, x: -screenW / 2
	image: "images/sky.png"

pageOverlay = new Layer
	parent: city
	width: Screen.width, height: Screen.height, backgroundColor: null
pageOverlay.style = "background": "linear-gradient(to bottom, rgba(24,48,81,0.6), rgba(24,48,81,0))"

if isFullscreen
	sky.width = screenW * 2

skyline = new Layer
	parent: city
	width: sky.width * 1.5
	height: screenH
	x: -screenW / 2, backgroundColor: null
# 	
buildings = new Layer
	parent: skyline
	width: skyline.width, height: skyline.width / 1500 * 352
	image: "images/ny.png"
	y: Align.bottom

if isFullscreen then buildings.y = Align.bottom(50 * x)

# List of garmentors
garmentors = [
	{ name: "benjamin", eta: 22 }
	{ name: "you"}
	{ name: "sebastiaan", eta: 24 }
]
allGarmentors = []
allGarY = []
allGarHeight = []
garTop = verticalSections.middle.top - 0 * x
garBottom = buildings.minY + 40 * x

for i,gar of garmentors
	
	deviation = Utils.randomNumber(-0.05,0.05)
	xPos = (skyline.width - 360) / garmentors.length * i + 360
	yPos = Utils.randomNumber(garTop,garBottom)
	
	garmentor = new Layer
		parent: skyline
		size: 34 * x
		x: 100 * x * i + 500, y: yPos
		backgroundColor: null
	
	avatar = new Layer
		parent: garmentor
		image: "images/garmentors/#{gar.name}.png"
		width: garmentor.width, height: garmentor.height
		opacity: 0
		scale: 0.5
		
	ring = new Layer
		parent: avatar
		width: garmentor.width + 12 * x, height: garmentor.height + 12 * x
		borderRadius: (garmentor.width + 12 * x) / 2, backgroundColor: null
	ring.style =
		"border": 3 * x + "px solid #183051"
	ring.center()
	
	eta = new Layer
		parent: garmentor, html: "ETA #{gar.eta} min", backgroundColor: null, height: 20 * x, y: -28 * x, opacity: 0
	eta.centerX()
	eta.style = 
		"text-align": "center"
		"font-size": 14 * x + "px"
		"line-height": "1.5"
		"font-family": "Roboto"
		"font-weight": "300"
	
	avatar.scale = Utils.randomNumber(0.75,1.25)
	
	if gar.name == "you"
		eta.html = "you"
		eta.scale = 1
		ring.opacity = 0
		garmentor.y = ( garBottom + garTop ) / 2
	
	pointer = new Layer
		parent: garmentor
		width: x, height: Screen.height - garmentor.height + 20 * x, y: garmentor.height + 20 * x
		backgroundColor: "rgba(255,255,255,0.5)"
	pointer.centerX()
	pointer.scaleY = 0
	
	allGarmentors.push(garmentor)
	allGarY.push(yPos)

buildings.bringToFront()

# Show garmentors
showGarmentors = (layer,i) ->
	avatar = layer.children[0]
	pointer = layer.children[2]
	delay = 0.2

	pointer.animate
		properties: scaleY: 1
		curve: "ease-in-out"
		time: 0.3
		delay: delay * i
	
	avatar.animate
		properties:
			scale: 1
			opacity: 1
		curve: "spring(200,20,10)"
		delay: (0.3 + delay) * i

hideGarmentors = (layer,i) ->
	avatar = layer.children[0]
	pointer = layer.children[2]
	delay = 0.2

	pointer.animate
		properties: scaleY: 0
		curve: "ease-in-out"
		time: 0.3
		delay: 0.1
	
	avatar.animate
		properties:
			scale: 0.5
			opacity: 0
		curve: "spring(200,20,10)"

# Pages
allPages = []
pages = new PageComponent width: screenW, height: screenH, parent: site.content
pages.scrollHorizontal = false
pages.animationOptions =
	curve: "spring(100,20,0)"

pages.mouseWheelEnabled = isFullscreen

pagesTotalWidth = screenW * (sections.length - 1)

for i,section of sections
	page = new Layer
		parent: pages.content
		name: section.name
		width: pages.width, height: pages.height
		y: i * pages.height
		backgroundColor: null
		opacity: 1
	
	usp = new Layer
		parent: page
		html: section.content
		backgroundColor: null
		width: 280 * x, y: 200 * x
	usp.centerX()
	usp.style =
		"font-family": "Roboto"
		"font-weight": "300"
		"font-size": 16 * x + "px"
		"line-height": "1.5"
	
	title = new Layer
		parent: usp
		html: section.title
		backgroundColor: null
		width: usp.width, height: 27 * x
		x: Align.left, y: Align.top(-(27 + 26) * x)
	title.style =
		"font-family": "Roboto Condensed"
		"text-transform": "uppercase"
		"font-size": "#{18*x}px"
		"line-height": "1.5"
		"letter-spacing": "1.33px"
		"font-weight": "400"
	
	allPages.push(page)

allPages[0].opacity = 1

# Fixed elements
fixed = new Layer
	backgroundColor: null
	width: Screen.width, height: Screen.height
	parent: site.content
	
logo = new Layer
	parent: fixed
	image: "images/g_logo.svg"
	width: 254 * x, height: 19 * x
	y: 150 * x
	
logo.centerX()

logo.states.add small: scale: 0.5, y: 60 * x

logo.states.animationOptions =
	curve: "spring(200,40,10)"

cta = new Layer
	parent: fixed
	width: 252 * x, height: 48 * x
	image: "images/cta.png"
	y: Align.bottom(-48 * x)
cta.centerX()

ctaHide = new Animation
	layer: cta
	properties: opacity: 0, y: Align.bottom
	curve: "ease-in-out"
	time: 0.2

ctaShow = ctaHide.reverse()

if isFullscreen || isTablet
	cta.width = 250 * x
	cta.height = 108 * x
	cta.image = "images/cta_tab.png"
	cta.y = Screen.height - 156 * x

ss_logo = new Layer
	parent: fixed
	image: "images/sslogo.svg"
	width: 120 * x, height: 14 * x
	x: 24 * x, y: 64 * x

ss_logo.states.add hide: opacity: 0

if isPhone || isTablet || isFullscreen and Utils.isPhone()

	ios = new Layer
		width: screenW
		height: 40 * x
	
	ios.style = 
		"background": "url(images/ios.png) rgba(250,250,250,0.9)"
		"-webkit-backdrop-filter": "blur(10px)"
		"box-shadow": "0 1px 0 #B2B2B2"
	if isTablet
		ios.style = "background-image": "url(images/ios_tab.png)"
			
	
	ios.onClick ->
		pages.snapToPage(allPages[0])

readMore = new Layer
	width: 100 * x, height: 50 * x
	backgroundColor: null
	parent: fixed
	x: Align.center
	y: 340 * x

readMore.style = 
	"font-size": "#{16*x}px"
	"font-family": "Roboto Condensed"
	"text-transform": "uppercase"
	"text-align": "center"
	"line-height": "1.5"

readMoreTxt = new Layer
	parent: readMore
	width: readMore.width, height: readMore.height / 2
	html: "Read more"
	backgroundColor: null

readMore.states.add
	hide: 
		y: 275 * x

readMoreTxt.states.add
	hide: opacity: 0
	
arrDown = new Layer
	width: 19 * x, height: 10 * x
	parent: readMore
	x: Align.center, y: Align.bottom
	image: "images/arr_down.png"

arrDownAnimation = new Animation
	layer: arrDown
	properties:
		opacity: 0
		y: Align.bottom(arrDown.height)
	time: 0.5
	delay: 1
	curve: "eae-in-out"

arrDownAnimation.onAnimationEnd ->
	arrDown.y = Align.bottom
	arrDown.animate
		properties: opacity: 1
		time: 0.4
		curve: "eae-in-out"
		delay: 0.5
	Utils.delay 1, ->
		arrDownAnimation.start()

arrDownAnimation.start()

arrDown.onClick ->
	pages.snapToPage(allPages[1])

# Appstore
appstore = new Layer
	width: screenW, height: screenH
	image: "images/appstore.png"

appstore.states.add
	hide:
		y: screenH
	show:
		y: 0
appstore.states.switchInstant("hide")

# Footer
footer = new Layer
	width: screenW, height: (280) * x + cta.height
	backgroundColor: "#f2f2f2"

footerBottom = new Layer
	parent: footer
	width: footer.width, height: 280 * x
	backgroundColor: "#e9e9e9"
	
footerImg = new Layer	
	parent: footerBottom
	width: 375 * x, height: 280 * x
	image: "images/footer.png"
# Add footer as page to site
site.addPage(footer,"bottom")

# Behavior
firstPage = 0
lastPage = allPages.length - 1

showGarmentor = Utils.throttle 0.5, (garmentor) ->
	garmentor.animate
		properties: opacity: 1

site.onScroll ->
	if site.direction == "up" && site.currentPage == city
		site.scrollVertical = false
		pages.scrollVertical = true

site.on "change:currentPage", ->
	if site.direction == "up"	
		site.scrollVertical = false
		pages.scrollVertical = true

# Click on down arrow go to next page
readMore.onClick ->
	current = pages.verticalPageIndex(pages.currentPage)
	next = current + 1
	if next < sections.length
		nextPage = allPages[current + 1]
		pages.snapToPage(nextPage)

# Page events
pages.on "change:currentPage", ->
	current = pages.verticalPageIndex(pages.currentPage)
	
	# If first page is left, shrink garmentor logo and hide ss logo
	if current == 1
		logo.states.switch("small")
		ss_logo.states.switch("hide")
		# and show garmentors and animate skyline
		skylineMoveRight.start()
		for i,gar of allGarmentors
			showGarmentors(gar,i)
		# move cta down
		if pages.direction == "down" then ctaHide.start()
		# Remove "read more" text
		readMore.states.next("hide")
		readMoreTxt.states.next("hide")
		
	# When you come back on first page make garmentor logo big and show ss logo again
	if current == 0
		logo.states.switch("default")
		ss_logo.states.switch("default")
		# and hide garmentors and stop skyline animation
		skylineMoveRight.stop()
		skylineMoveLeft.stop()
		for i,gar of allGarmentors
			hideGarmentors(gar,i)
		# and move cta back up
		ctaShow.start()
		# Place "read more" text back
		readMore.states.next("default")
		readMoreTxt.states.next("default")
	
	if current == lastPage
		# show cta
		ctaShow.start()
		# Hide readmore
		readMore.opacity = 0
	if current == lastPage - 1
		# hide cta
		ctaHide.start()
		# show readMore
		readMore.opacity = 1

pages.onScroll ->
	currentPage = pages.verticalPageIndex(pages.currentPage)
	
	deltaY = Math.abs pages.scrollY - pages.currentPage.y
	# Fade out currentPage
	pages.currentPage.opacity = Utils.modulate deltaY, [0,200], [1,0], false
	pages.currentPage.scale = Utils.modulate deltaY, [0,200], [1,0.9], false
	
	if currentPage != lastPage
		site.scrollVertical = false
		pages.scrollVertical = true
	else
		if pages.direction == "down"
			site.scrollVertical = true
			pages.scrollVertical = false
	
	
	
# Skyline pan
skylineA = -screenW / 2
skylineB = -skyline.width / 5

# Continuous motion
skylineMoveRight = new Animation
	layer: skyline
	properties:
		x: skylineB
	time: 30
	curve: "ease-out-out"
skylineMoveLeft = skylineMoveRight.reverse()

skylineMoveRight.onAnimationEnd ->
	skylineMoveLeft.start()

skylineMoveLeft.onAnimationEnd ->
	skylineMoveRight.start()

# print skyline.x - skylineA
# print allGarmentors[allGarmentors.length - 1].x

# Sky pan, dependant on x change of skyline
skyline.on "change:x", ->
	sky.x = Utils.modulate @x, [skylineA, skylineB], [-screenW / 2,-sky.width + screenW]
# 	print @x - skylineA
	for i,gar of allGarmentors
		garX = gar.x - @x

cta.onClick ->
	appstore.states.next("show")

appstore.onSwipeDown ->
	@states.next("hide")

# Toggles
hash = ""
location = ""

if window.location.hash
	hash = window.location.hash.substring(1); #Puts hash in variable, and removes the # character
	location = hash
else
	location = Utils.randomChoice(["amsterdam","newyork"])

if location == "amsterdam"
	buildings.image = "images/ams.png"
else if location == "newyork"
	buildings.image = "images/ny.png"
else if location == "dallas"
	buildings.image = "images/dal.png"


