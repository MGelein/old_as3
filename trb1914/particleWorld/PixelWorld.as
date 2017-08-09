package trb1914.particleWorld
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * a class that manages all the particles
	 * @author Mees Gelein
	 */	
	public class PixelWorld extends Sprite
	{
		//internal static vars
		internal static const TO_RADIANS:Number = 180 / Math.PI;
		internal static var GRAVITY:Point = new Point(0, 1);
		internal static var FRICTION:Number = 0.95;
		internal static var BOUNDS_ON:Boolean = false;
		internal static var SCREEN:ParticleBounds;
		internal static var allowCreate:Boolean = true;
		internal static var zoom:Number;
		internal static var particleCount:int = 0;
		internal static var sourceCount:int = 0;
		internal static var attractorCount:int = 0;
		internal static var followAttractor:ParticleAttractor = null;
		
		//stuff for the pseudo randomness
		private	static var maxRandomNumbers:int;
		private static var _randomList:Vector.<Number>;
		private static var _randomIndex:int;
		
		//stuff for precached sin and cos
		private static var _cosList:Vector.<Number>;
		private static var _sinList:Vector.<Number>;
		
		//heads of all the linked lists
		private static var _headParticle:Particle = null;
		private static var _headSource:Source = null;
		private static var _headAttractor:ParticleAttractor = null;
		private static var _headPool:Particle = null;
		private static var _particlesToRemove:Vector.<Particle> = new Vector.<Particle>();
		private static var _sourcesToRemove:Vector.<Source> = new Vector.<Source>();
		private static var _attractorsToRemove:Vector.<ParticleAttractor> = new Vector.<ParticleAttractor>();
		
		//stuff for following the mouse
		private var x_mouse:int = 0;
		private var y_mouse:int = 0;
		internal var _followSource:Source = null;
		
		//rendering stuff
		private var _bitmap:Bitmap;
		private var _draw:BitmapData;
		private var _clear:BitmapData;
		private var _data:BitmapData;
		private var _effects:ParticleEffects;
		private var _sourceColor:uint = 0xFFFFFFFF;
		private var _attractorColor:uint = 0xFF00FFFF;
		private var _trailAlpha:Number = 0.6;
		private var _bgColor24:uint = 0x000000;
		private var _animating:Boolean = true;
		private var _timeInterval:Number = 1;
		private var _pauseShape:Shape;
		private var _creatingParticles:Boolean = true;
		private var _zoom:Number;
		
		
		/**
		 * makes a new instance of pixelWorld.
		 * @param	parent			the parent displayObject to which this world can be added
		 * @param	width			the width of the particles area
		 * @param	height			the height of the particles area
		 * @param	position		the position on screen of the particles area
		 * @param	zoom			the amount of zoom applied to the particles area
		 * @param 	bgColor24		the backgroundcolor, it defaults to black, in a 24-bit color format
		 */
		public function PixelWorld(parent:DisplayObjectContainer, width:Number, height:Number, position:Point = null, zoom:Number = 1, bgColor24:uint = 0x000000) 
		{
			PixelWorld.generateRandomNumbers(1000);
			PixelWorld.generateCosSinList();
			parent.addChild(this);
			PixelWorld.zoom = zoom;
			if (position == null) position = new Point();
			x = position.x;
			y = position.y;
			var w:Number = width / zoom;
			var h:Number = height / zoom;
			_zoom = zoom;
			SCREEN = new ParticleBounds(0, 0, w, h);
			setBackgroundColor(bgColor24);
			addEventListener(Event.ENTER_FRAME, update);
			graphics.lineStyle(4, 0, 0.3);
			graphics.drawRect(0, 0, width, height);
			graphics.lineStyle(2, 0, 0.3);
			graphics.drawRect(0, 0, width, height);
		}
		/**
		 * called automatically by an enterFramelistener.s
		 * called automatically by an enterFramelistener.s
		 * this function can be called manually.
		 * @param	e		an OPTIONAL event. Only passed if called by an
		 *  enterFramelistener. 
		 */
		public function update(e:Event = null):void
		{
			moveParticles();	
			drawData();
			updateMouse();
			cleanLists();
		}
		/**
		 * clears the particles to be removed
		 */
		private function cleanLists():void 
		{
			var i:int, max:int = _particlesToRemove.length;
			if (max > 0) {
				for (i = 0; i < max; i++) {
					saveRemoveParticle(_particlesToRemove[i]);
				}_particlesToRemove = new Vector.<Particle>();
			}
			max = _sourcesToRemove.length;
			if(max > 0){
				for (i = 0; i < max; i++) {
					saveRemoveSource(_sourcesToRemove[i]);
				}_sourcesToRemove = new Vector.<Source>();
			}			
			max = _attractorsToRemove.length;
			if (max > 0) {
				for (i = 0; i < max; i++) {
					saveRemoveAttractor(_attractorsToRemove[i]);
				}_attractorsToRemove = new Vector.<ParticleAttractor>();
			}
			
		}
		/**
		 * used to make sources and attractors follow the mouse
		 */
		private function updateMouse():void 
		{
			if (_followSource != null) {
				x_mouse = this.mouseX / zoom;
				y_mouse = this.mouseY / zoom;
				_followSource.x = x_mouse;
				_followSource.y = y_mouse;
			}	
			if (followAttractor != null) {
				x_mouse = this.mouseX / zoom;
				y_mouse = this.mouseY / zoom;
				followAttractor.x = x_mouse;
				followAttractor.y = y_mouse;
			}
		}
		/**
		 * a number between 0 and 1 determining if the particles leave a trail
		 * with 0 being no trail and 1 being don't erase trail. Effectively the alpha
		 * value of the trail they leave, or the inverse alpha of the mask drawn 
		 * every frame
		 * @param	trail		the amount of trail, defaults to 0.4
		 */
		public function setTrail(trail:Number = 0.4):void
		{
			if (trail > 1) trail = 1;
			else if (trail < 0) trail = 0;
			trail = 1 - trail;
			_trailAlpha = trail;
			var bgColor:uint = Color32.toColor32(_bgColor24, trail);
			_clear = new BitmapData(this.width, this.height, true, bgColor);
		}
		public function getTrail():Number
		{
			return _trailAlpha;
		}
		/**
		 * draws all the particles in the particles list
		 */
		private function drawData():void 
		{
			_draw.lock();
			var p:Particle = _headParticle;
			while (p != null) {
				_draw.setPixel32(p.x, p.y, p.c);
				if (p != p.nxt) p = p.nxt;
				else break;
			}
			
			var a:ParticleAttractor = _headAttractor;
			while (a != null) {
				_draw.setPixel32(a.x, a.y, _attractorColor);
				if (a != a.next) a = a.next;
				else break;
			}
			
			var s:Source = _headSource;
			while (s != null) {
				_draw.setPixel32(s.x, s.y, _sourceColor);
				if (s != s.next) s = s.next;
				else break;
			}
			_draw.unlock();
			_data.draw(_draw);
			_draw.draw(_clear);			
		}
		/**
		 * moves all the particles and updates all the sources
		 */
		private function moveParticles():void 
		{
			var p:Particle = _headParticle;
			while (p != null) {
				p.update(_timeInterval);
				if (p != p.nxt) p = p.nxt;
				else break;
			}
			var s:Source = _headSource;
			while (s != null) {
				s.update(_timeInterval);
				if (s != s.next) s = s.next;
				else break;
			}
		}
		/**
		 * used to add a new source to the world. The source will be automatically added 
		 * to the sources list to be updated every frame
		 * @param	source		the source to be added to the world
		 */
		public function addSource(source:Source):void
		{
			if (_headSource == null) {
				_headSource = source;
			}else {
				source.next = _headSource;
				_headSource = source;
				source.next.last = source;
			}
			source.setWorld(this);
			sourceCount++;
		}
		/**
		 * the amount of particles currently on screen
		 * @return		the amount of particles
		 */
		public function getParticleCount():int
		{
			return particleCount;
		}
		/**
		 * the amount of sources currently on screen
		 * @return		the amount of sources
		 */
		public function getSourceCount():int
		{
			return sourceCount;
		}
		/**
		 * the amount of attractors currently on screen
		 * @return		the amount of attractors
		 */
		public function getAttractorCount():int
		{
			return attractorCount;
		}
		/**
		 * sets the playback speed, with 1 being normal, .5 being half speed, and
		 * 2 being double speed
		 * @param	value
		 */
		private function setPlayBackSpeed(value:Number):void
		{
			if (value < 0) value = 0;
			_timeInterval = value;
			// TODO:  doesnt work yet, the playbackspeed its private for now
		}
		/**
		 * pauses the world. The world can be resumed by calling restart();
		 * @param displayPauseSign		indicates if you display the default pause sign
		 */
		public function pause(displayPauseSign:Boolean = true):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			if ((_pauseShape == null) && (displayPauseSign)) {
				_pauseShape = new Shape();
				addChild(_pauseShape);
				var g:Graphics = _pauseShape.graphics;
				var w:Number = SCREEN.w * zoom;
				var h:Number = SCREEN.h * zoom;
				g.beginFill(0, 0.2);
				g.drawRect(0, 0, w, h);
				g.endFill();
				g.beginFill(0xFFFFFF, 0.2);
				g.drawRect((w >> 1) - 30, (h >> 1) - 75, 30, 150);
				g.drawRect((w >> 1) + 30, (h >> 1) - 75, 30, 150);
				g.endFill();
			}
			trace("has :" +hasEventListener(Event.ENTER_FRAME));
		}
		/**
		 * restarts the world after the world has stopped animating
		 */
		public function restart():void
		{
			addEventListener(Event.ENTER_FRAME, update);
			if (_pauseShape != null) {
				_pauseShape.graphics.clear();
				removeChild(_pauseShape);
				_pauseShape = null;
			}
		}
		/**
		 * stops creating particles and clears the screen
		 */
		public function suddenStop():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			particleCount = 0;
			_headParticle = null;
			_headSource = null;
			_headAttractor = null;
			drawData();
		}
		/**
		 * the world is now allowed to make particles
		 */
		public function startCreate():void
		{
			allowCreate = true;
		}
		/**
		 * the world is not allowed to make any particles anymore
		 */
		public function stopCreate():void
		{
			allowCreate = false;
		}
		/**
		 * this boolean value sets if the particles bounce of the walls or that they
		 * just die when they go out of screen
		 * @param	value			the boolean flag
		 */
		public function setBounceOffWalls(value:Boolean):void
		{
			PixelWorld.BOUNDS_ON = value;
		}
		/**
		 * sets the bounciness of the particles, with 1 being totally elastic,
		 * and 0 being no bounce. defaults to 0.6;
		 * @param	value			the bounce value, between 0 and 1
		 */
		public function setBounciness(value:Number):void
		{
			if (value > 1) value = 1;
			else if (value < 0) value = 0;
			Particle.BNCE = -value;
		}
		/**
		 * set the world gravity. The amount of gravity applied every frame
		 * the default settings provide a realistic earth like gravity
		 * @param	xGrav			the amount of horizontal gravity
		 * @param	yGrav			the amount of vertical gravity				
		 */
		public function setGravity(xGrav:Number = 0, yGrav:Number = 1):void
		{
			GRAVITY = new Point(xGrav, yGrav);
		}
		/**
		 * sets the amount of friction applied every frame on every particle 
		 * @param	friction		usually between 0 and 1.
		 * 							with 0 being no friction and 1 being only friction 							
		 */
		public function setFriction(friction:Number):void
		{
			FRICTION = 1 - friction;
		}
		/**
		 * adds a attractor to the world. The color of the attractor in the world can
		 * be changed using the Pixelworld.changeColorScheme() function
		 * @param	attractor
		 */
		public function addAttractor(attractor:ParticleAttractor):void
		{
			if (_headAttractor == null) {
				_headAttractor = attractor;
			}else {
				_headAttractor.last = attractor;
				attractor.next = _headAttractor;
				_headAttractor = attractor;
			}
			attractorCount++;
		}
		/**
		 * change the colors used for static objects like sources and attractors.
		 * set 0 if you want them to be invisible.
		 * @param	sourceColor				the color of a source
		 * @param	attractorColor			the color of an attractor
		 */
		public function setColorScheme(sourceColor:uint = 0xFFFFFFFF, attractorColor:uint = 0xFF00FFFF):void
		{
			_attractorColor = attractorColor;
			_sourceColor = sourceColor;			
		}
		/**
		 * sets the background color of the canvas. Must be a 24-bit color, 
		 * transparency is not yet supported
		 * @param	color			24-bit color value of the background
		 */
		public function setBackgroundColor(color24:uint):void
		{
			var rect:Rectangle = PixelWorld.SCREEN.getRect();
			var z:Number = PixelWorld.zoom;
			var color32:uint = Color32.toColor32(color24, 1);
			var w:int = rect.width;
			var h:int = rect.height;
			_data = new BitmapData(w, h, true, color32);
			color32 = Color32.toColor32(color24, 0);
			_draw = new BitmapData(w, h, true, color32);
			color32 = Color32.toColor32(color24, _trailAlpha);
			_clear = new BitmapData(w, h, true, color32);
			_bgColor24 = color24;
			if (_bitmap != null) removeChild(_bitmap);
			addChild(_bitmap = new Bitmap(_data));
			_bitmap.scaleX = _bitmap.scaleY = zoom;
			_effects = new ParticleEffects(_bitmap);
		}
		/**
		 * returns the world in a saveable format, in a string
		 * @return		the save format
		 */
		public function getSaveFormat():String
		{
			return String("w:" + this.x + ":" + this.y + ":" + GRAVITY.x + ":" + GRAVITY.y + ":" + _bgColor24+ ":" +
			SCREEN.w + ":" + SCREEN.h + ":" + ((BOUNDS_ON)?1: -1) + ":" + zoom +":" + FRICTION + ":" +
			_sourceColor + ":" + _attractorColor + ":" + _trailAlpha + "\n");
		}
		/**
		 * returns the complete game including all sources, attractors and the current
		 * world
		 * @return		the saved game
		 */
		public function getSavedGameState():String
		{
			var frmt:String = getSaveFormat();
			var s:Source = _headSource;
			while (s != null) { 
				frmt += s.getSaveFormat(); 
				if (s != s.next) s = s.next;
				else break;
			}
			var a:ParticleAttractor = _headAttractor;
			while (a != null) { 
				frmt += a.getSaveFormat(); 
				if (a != a.next) a = a.next;
				else break;
			}
			return frmt;
		}
		/**
		 * returns the source at a given location. This translates the coordinates
		 * to pixelworld coordinates. Returns null if no Source is found within given radius
		 * @param	x		the x on the world sprite
		 * @param	y		the y on the world sprite
		 * @param	radius  the radius in which a source can be selected
		 * @return			returns null if no source is found in given radius
		 */
		public function getSourceAtPos(x:Number, y:Number, radius:int = 4):Source
		{
			x = x / zoom;
			y = y / zoom;
			var s:Source = _headSource;
			var nearest:Source;
			var minDist:Number = 100000000000000, dx:Number, dy:Number, dist:Number;
			while (s != null) {
				dx = x - s.x;
				dy = y - s.y;
				dist = Math.sqrt(dx * dx + dy * dy);
				if (dist < minDist) {
					minDist = dist;
					nearest = s;
				}
				if (s != s.next) s = s.next;
				else break;
			}
			if (minDist <= radius) {
				return nearest;
			}else {
				return null;
			}
		}
		/**
		 * returns the attractor at a given location. This translates the coordinates
		 * to pixelworld coordinates. Returns null if no attractor is found within the radius
		 * @param	x		the x on the world sprite
		 * @param	y		the y on the world sprite
		 * @param	radius  the radius in which a attractor can be selected
		 * @return			returns null if no attractor is found in given radius
		 */
		public function getAttractorAtPos(x:Number, y:Number, radius:int = 4):ParticleAttractor
		{
			x = x / zoom;
			y = y / zoom;
			var a:ParticleAttractor = _headAttractor;
			var nearest:ParticleAttractor;
			var minDist:Number = 100000000000000, dx:Number, dy:Number, dist:Number;
			while (a != null) {
				dx = x - a.x;
				dy = y - a.y;
				dist = Math.sqrt(dx * dx + dy * dy);
				if (dist < minDist) {
					minDist = dist;
					nearest = a;
				}
				if (a != a.next) a = a.next;
				else break;
			}
			if (minDist <= radius) {
				return nearest;
			}else {
				return null;
			}
		}
		/**
		 * returns the closest attractor or source to the given location, the location
		 * will be translated from sprite location to pixelworld location.
		 * @param	x		the x-coordinate on the world-sprite
		 * @param	y		the y-coordinate on the world-sprite
		 * @param	radius	the radius to look for objects
		 * @return		an array with the first element containing the class of the object
		 * and the second element containing the object. for example:
		 * Array[0] = Source;
		 * Array[1] = [Object Source];
		 * or
		 * Array[0] = ParticleAttractor
		 * Array[1] = [Object ParticleAttractor];
		 * 
		 * This will return an empty array if no object is found
		 */
		public function getObjectAtPos(x:Number, y:Number, radius:int = 4):Array
		{
			var closestAttractor:ParticleAttractor = getAttractorAtPos(x, y, radius);
			var closestSource:Source = getSourceAtPos(x, y, radius);
			var array:Array = [];
			if ((closestAttractor != null) && (closestSource != null)) {
				
			}else if (closestAttractor != null) {
				array[0] = ParticleAttractor;
				array[1] = closestAttractor;
			}else if (closestSource != null) {
				array[0] = Source;
				array[1] = closestSource;
			}
			return array;
		}
		
		/////////////////////////////////
		//	STATIC FUNCTIONS
		/////////////////////////////////
		
		/**
		 * this function is used by particles to remove themselves
		 * @param	particle		the particle to remove
		 */
		internal static function removeParticle(particle:Particle):void
		{
			_particlesToRemove[_particlesToRemove.length] = particle;
		}
		/**
		 * this function is used by the world to actually remove the particle
		 * @param	pp			the particle to remove
		 */
		private static function saveRemoveParticle(pp:Particle):void
		{
			if (pp == _headParticle) {
				pp.nxt = _headParticle;
			}else {
				var prev:Particle = pp.last;
				var next:Particle = pp.nxt;
				if (prev != null) prev.nxt = next;
				if (next != null) next.last = prev;
			}
			particleCount--;
			particleCount--;
			
		}
		/**
		 * this function is used by sources to remove themselves
		 * @param	source			the source to remove
		 */
		internal static function removeSource(source:Source):void
		{
			_sourcesToRemove[_sourcesToRemove.length] = source;
		}
		/**
		 * this function is used by the world to actually remove the source
		 * @param	source			the source to remove
		 */
		private static function saveRemoveSource(source:Source):void
		{
			if (source == _headSource) {
				source.next = _headSource;
			}else {
				var prev:Source = source.last;
				var next:Source = source.next;
				if (prev != null) prev.next = next;
				if (next != null) next.last = prev;
			}
			sourceCount--;
		}
		/**
		 * a pseudo random number generator. Before you can used this, you
		 * have to generate a list of randomNumbers with generateRandomNumbers();
		 * @return
		 */
		internal static function random():Number
		{
			_randomIndex++;
			if (_randomIndex == maxRandomNumbers) { _randomIndex = 0; _randomList.reverse(); }
			return _randomList[_randomIndex];
		}
		/**
		 * a pre cached cos calculator. angles (a) are per .5 degree.
		 * @param	a		the angle in degrees
		 */
		internal static function cos(a:Number):Number
		{
			if (a > 359) a = 359;
			return _cosList[int(a * 2)];
		}
		/**
		 * a pre cached sin calculator. angles (a) are per .5 degree.
		 * @param	a		the angle in degrees
		 */
		internal static function sin(a:Number):Number
		{
			if (a > 359) a = 359;
			return _sinList[int(a * 2)];
		}
		/**
		 * caches the cos and sin list with a .5 degree interval. 
		 */
		private static function generateCosSinList():void
		{
			_cosList = new Vector.<Number>(720, true);
			_sinList = new Vector.<Number>(720, true);
			var i:int = 0, max:int = 720;
			for (i = 0; i < max; i++) {
				_cosList[i] = Math.cos((i * .5) * PixelWorld.TO_RADIANS);
				_sinList[i] = Math.sin((i * .5) * PixelWorld.TO_RADIANS);
			}
		}
		/**
		 * generates a given amount of random numbers. This list is used because of speed
		 * issues with Math.random().
		 * @param	amount		the amount of randomNumbers to create
		 */
		private static function generateRandomNumbers(amount:int = 100):void
		{
			maxRandomNumbers = amount;
			_randomIndex = 0;
			_randomList = new Vector.<Number>(maxRandomNumbers, true);
			var i:int;
			var max:int = _randomList.length;
			for (i = 0; i < max; i++)_randomList[i] = Math.random();
		}
		/**
		 * generate a given amount of random 32-bit colors in an Array.
		 * @param	amount		the amount of colors to be generated
		 * @return
		 */
		internal static function generateRandomColors(amount:int):Array
		{
			var i:int; var colors:Array = [];
			for (i = 0; i < amount; i++) {
				colors[i] = Color32.toColor32(0xFFFFFF * random(), 1);
			}
			return colors;
		}
		/**
		 * this function is used by attractors to remove themselves
		 * @param	attractor		the attractor to remove
		 */		
		internal static function removeAttractor(attractor:ParticleAttractor):void
		{
			_attractorsToRemove[_attractorsToRemove.length] = attractor;
		}
		/**
		 * this function is used by the world to actually remove the attractor
		 * @param	attractor		the attractor to remove
		 */		
		internal static function saveRemoveAttractor(attractor:ParticleAttractor):void
		{
			if (attractor == _headAttractor) {
				attractor.next = _headAttractor;
			}else {
				var n:ParticleAttractor = attractor.next;
				var p:ParticleAttractor = attractor.last;
				if (p != null) p.next = n;
				if (n != null) n.last = p;
			}
			attractorCount--;
		}
		/**
		 * makes a world from a world saved format
		 * @param	frmt			the format
		 * @return		the world that is made
		 */
		public static function getWorldFromFormat(parent:DisplayObjectContainer, frmt:String):PixelWorld
		{
			var world:PixelWorld;
			var i:int = 0;
			var lines:Array = frmt.split(":"); i++; 
			var tx:int = parseInt(lines[i] as String); i++;
			var ty:int = parseInt(lines[i] as String); i++;
			var hGrav:Number = parseFloat(lines[i] as String); i++;
			var vGrav:Number = parseFloat(lines[i] as String); i++;
			var bgColor:Number = parseInt(lines[i] as String); i++;
			var w:int = parseInt(lines[i] as String); i++; 
			var h:int = parseInt(lines[i] as String); i++; 
			var boundsOn:Boolean = parseInt(lines[i] as String) > 0; i++;
			var theZoom:Number = parseFloat(lines[i] as String); i++;
			var friction:Number = parseFloat(lines[i] as String); i++;
			var srcColor:uint = parseInt(lines[i] as String); i++;
			var attColor:uint = parseInt(lines[i] as String); i++;
			var tAlpha:Number = parseFloat(lines[i] as String);
			world = new PixelWorld(parent, w * theZoom , h * theZoom , new Point(tx, ty), theZoom, bgColor);
			world.setGravity(hGrav, vGrav);
			world.setBounceOffWalls(boundsOn);
			world.setFriction(1 - friction);
			world.setTrail(1 - tAlpha);
			world.setColorScheme(srcColor, attColor);			
			return world;
		}
		/**
		 * makes a complete world from a saved format
		 * @param	parent		the parent to which the world can be added
		 * @param	frmt		the saved format
		 * @return 	the world so you can use it to
		 */
		public static function getAllFromFormat(parent:DisplayObjectContainer, frmt:String):PixelWorld
		{
			var expressions:Array = frmt.split("\n");
			var sources:Vector.<Source> = new Vector.<Source>();
			var world:PixelWorld;
			var attractors:Vector.<ParticleAttractor> = new Vector.<ParticleAttractor>();
			var i:int, max:int = expressions.length, cExp:String;
			world = PixelWorld.getWorldFromFormat(parent, expressions[0]);
			for (i = 1; i < max; i++) {
				cExp = expressions[i] as String;
				if (cExp.charAt() == "s") {
					world.addSource(Source.getSourceFromFormat(cExp));
				}else if (cExp.charAt() == "a") {
					world.addAttractor(ParticleAttractor.getAttractorFromFormat(cExp));
				}
			}	
			return world
		}
		
		/////////////////////////////////
		//	GETTERS AND SETTERS
		/////////////////////////////////
		
		/**
		 * offers acces to some methods to set some standard bitmap filters
		 */
		public function get effects():ParticleEffects 
		{
			return _effects;
		}
		/**
		 * offers acces to some methods to set some standard bitmap filters
		 */
		public function set effects(value:ParticleEffects):void 
		{
			_effects = value;
		}
		
		/**
		 * the start of the linked list of particles
		 */
		static internal function get headParticle():Particle 
		{
			return _headParticle;
		}
		/**
		 * the start of the linked list of particles
		 */
		static internal function set headParticle(value:Particle):void 
		{
			_headParticle = value;
		}
		/**
		 * the start of the linked list of attractors
		 */
		static internal function get headAttr():ParticleAttractor
		{
			return _headAttractor;
		}
		/**
		 * the start of the linked list of the particle pool
		 */
		static internal function get headPool():Particle 
		{
			return _headPool;
		}
		/**
		 * the start of the linked list of the particle pool
		 */
		static internal function set headPool(value:Particle):void 
		{
			_headPool = value;
		}
		/**
		 * returns a boolean value indicating if the world is making particles
		 * setting this automatically calls pause or resume, depending on the 
		 * current state
		 */
		public function get animating():Boolean 
		{
			return _animating;
		}
		/**
		 * returns a boolean value indicating if the world is making particles
		 * setting this automatically calls pause or resume, depending on the 
		 * current state
		 */
		public function set animating(value:Boolean):void 
		{
			if (!value) pause();
			if (value) { pause(); restart(); }
			_animating = value;
		}
		/**
		 * a flag that can be changed so you can mark if the world is making particles
		 */
		public function get creatingParticles():Boolean 
		{
			return _creatingParticles;
		}
		/**
		 * a flag that can be changed so you can mark if the world is making particles
		 */
		public function set creatingParticles(value:Boolean):void 
		{
			_creatingParticles = value;
		}
		
		internal function getZoom():Number
		{
			return _zoom;
		}
		
	}

}