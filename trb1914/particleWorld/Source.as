package trb1914.particleWorld 
{
	import trb1914.particleWorld.Color32;
	import trb1914.particleWorld.PixelWorld;
	import trb1914.particleWorld.Particle;
	/**
	 * a class that contains a basic source
	 * @author Mees Gelein
	 */
	public class Source
	{
		private var _color:uint = 0;
		private var _t:int = 0;
		private var _perFrame:int = 1;
		private var _delay:int = 0;
		private var _x:int;
		private var _y:int;
		private var _w:PixelWorld;
		private var _cSpeed:Number = 1;
		
		//attracting stuff
		private var _attr:Boolean = false;
		private var _attrFrc:Number = 0;
		
		//linked list stuff
		private var _next:Source;
		private var _last:Source;
		
		//age stuff
		private var _minLive:int = 60;
		private var _maxLive:int = 120;
		
		//fading
		private var _fade:Boolean = false;
		
		//mouse following
		internal var _followMouse:Boolean = false;
		private var _followingSet:Boolean = false;
		
		//rotating
		private var _rotating:Boolean = false;
		private var _vr:Number = 0;
		private var _rot:Number = 0;
		private var _perPp:Number = 0;
		
		//colorArray stuff
		private var _cArray:Array = [];
		private var _maxVel:Number = 10;
		private var _cFromArr:Boolean = false;
		private var p:Particle;
		
		
		public function Source(x:Number, y:Number, color:uint = 0) 
		{
			_y = y / PixelWorld.zoom;
			_x = x / PixelWorld.zoom;
			_color = color;			
		}
		/**
		 * makes all the particles
		 * @param	interval
		 */
		internal function update(interval:Number = 1):void
		{
			_t++;
            if (_t > _delay) {
				_t = 0;
				var i:int;				
				for (i = 0; i < _perFrame; i++) {
					makeParticle();
				}
			}
			if (_followMouse) {
				if(!_followingSet) {
					_followingSet = true;
					setMouse(true);
				}
			}else if (!_followMouse) {
				if (!_followingSet) {
					_followingSet = true;
					setMouse(false);
				}
			}
		}
		
		/**
		 * for internal use only, to set it to _world._followMouse, only after _world
		 * is no longer null
		 */
		private function setMouse(value:Boolean):void 
		{
			if ((_w._followSource == null)&&(value)) {
				_w._followSource = this;
			}else if ((_w._followSource == this) && (!value)) {
				_w._followSource = null;
			}
		}
		/**
		 * makes a particle, for internal use only
		 */
		private function makeParticle():void 
		{
			if (PixelWorld.allowCreate) {
				if (_cFromArr) {
					var index:int = int(_cArray.length * PixelWorld.random());
					_color = _cArray[index];
				}
				p = new Particle(_x, _y, _color, this);
				
				if (_fade) p.fading = _fade;
				PixelWorld.particleCount++;
				
				if (PixelWorld.headParticle == null) {
					PixelWorld.headParticle = p;
				}else {
					PixelWorld.headParticle.last = p;
					p.nxt = PixelWorld.headParticle;
					PixelWorld.headParticle = p;
				}
				if (_rotating) {
					p.setAngVel(_rot, _maxVel);
					_rot += _perPp;
				}else {
					p.setRandomSpeed(_maxVel >> 1);
				}
			}
		}
		/**
		 * this safely removes the source from the world
		 */
		public function removeMe():void
		{
			PixelWorld.removeSource(this);
		}
		/**
		 * sets the maximum speed at which the particle is launched.
		 * The speed cap for launch speed
		 * @param	maxSpeed	a number defining the speed in pixels/frame
		 */
		public function setParticleLaunchSpeed(maxSpeed:Number = 10):void
		{
			_maxVel = maxSpeed;
		}
		/**
		 * used to set the color of the source in a 32-bit color format
		 * @param	color32			the color in a 32-bit color format
		 */
		public function setColor(color32:uint):void
		{
			_color = color32;
			_cFromArr = false;
			_cArray = null;
		}
		/**
		 * used to set the color if you dont like using 32-bit color values
		 * @param	color24			the color in a 24-bit color format
		 * @param	alpha			the alpha value, from 0 to 1
		 */
		public function setColor2(color24:uint, alpha:Number = 1):void
		{
			_color = Color32.toColor32(color24, alpha);
			_cFromArr = false;
			_cArray = null;
		}
		/**
		 * sets the source to attract it's particles
		 * @param	attractPower		think of this as a spring constant
		 * so usually between 0 and 1
		 */
		public function setAttracting(attractPower:Number = 0.1):void
		{
			if (attractPower == 0)_attr = false;
			else _attr = true;
			_attrFrc = attractPower;
		}
		/**
		 * sets the source to be a burst source
		 * @param	delay			how many frames between each burst
		 * @param	perFrame		the amount of particles released each burst
		 */
		public function setBurst(delay:int, perFrame:int):void
		{
			_delay = delay;
			_perFrame = perFrame;
			_perPp = _vr / perFrame;
		}
		/**
		 * sets the colors from an array
		 * @param	colors			the colors to use
		 */
		public function setColorsFromArray(colors:Array):void
		{
			_cArray = colors;
			_cFromArr = true;
		}
		/**
		 * controls wheter the particles of this source fade over time,
		 * instead of popping out of existence when they die.
		 * @param	value			a boolean flag indicating if the particles fade out
		 */
		public function setFadingParticles(value:Boolean = true):void
		{
			_fade = value;
		}
		/**
		 * indicates if the source should follow the mouse.
		 * Note: Only one source can follow the mouse
		 *  at a time
		 * @param	value
		 */
		public function setFollowMouse(value:Boolean = true):void
		{
			_followMouse = value;
			_followingSet = false;
		}
		/**
		 * sets the amount of particles that are released per frame
		 * @param	perFrame		the amount of particles per frame
		 */
		public function setIntensity(perFrame:Number):void
		{
			_perFrame = perFrame;
			_delay = 0;
			_t = 0;
			_perPp = _vr / _perFrame;
		}
		/**
		 * sets the amount of frame a particle usually lives, some may
		 * live longer, some may die sooner.
		 * @param	value			the amount of frames a particle lives
		 */
		public function setParticleAge(value:int = 90):void
		{
			var age:int = value << 1;
			age /= 3;
			_minLive = age;
			_maxLive = _minLive << 1;
			trace("min: " + _minLive + " max:" + _maxLive);
		}
		/**
		 * set the source to rotate.
		 * @param	vr			the amount of degrees the source rotates, not exact!
		 */
		public function setRotating(vr:int = 0):void
		{
			_vr = vr * PixelWorld.TO_RADIANS;
			_perPp = _vr / _perFrame;
			if (_vr == 0)_rotating = false;
			else _rotating = true;
		}
		
		/**
		* used by the world to make a reference to itself
		* @param	world
		*/
		internal function setWorld(world:PixelWorld):void
		{
			_w = world;
		}
		/**
		 * makes the source use random colors
		 * @param	amount		the amount of colors to use
		 */
		public function useRandomColors(amount:int):void
		{
			_cArray = PixelWorld.generateRandomColors(amount);
			_cFromArr = true;
		}
		/**
		 * the next element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		internal function get next():Source 
		{
			return _next;
		}
		/**
		 * the next element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		internal function set next(value:Source):void 
		{
			_next = value;
		}
		/**
		 * the last element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		internal function get last():Source 
		{
			return _last;
		}
		/**
		 * the last element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		internal function set last(value:Source):void 
		{
			_last = value;
		}
		/**
		 * the x-coordinate of the source in the world, be careful when setting
		 * this, because if the world zoom level is 2, you have to halve these
		 * values
		 */
		public function get x():int 
		{
			return _x;
		}
		/**
		 * the x-coordinate of the source in the world, be careful when setting
		 * this, because if the world zoom level is 2, you have to halve these
		 * values
		 */
		public function set x(value:int):void 
		{
			_x = value;
		}
		/**
		 * the y-coordinate of the source in the world, be careful when setting
		 * this, because if the world zoom level is 2, you have to halve these
		 * values
		 */
		public function get y():int 
		{
			return _y;
		}
		/**
		 * the y-coordinate of the source in the world, be careful when setting
		 * this, because if the world zoom level is 2, you have to halve these
		 * values
		 */
		public function set y(value:int):void 
		{
			_y = value;
		}
		/**
		 * the minimum amount of frames a particle lives
		 */
		internal function get minLive():int 
		{
			return _minLive;
		}
		/**
		 * the minimum amount of frames a particle lives
		 */
		internal function set minLive(value:int):void 
		{
			_minLive = value;
		}
		/**
		 * the maximum amount of frames a particle lives
		 */
		internal function get maxLive():int 
		{
			return _maxLive;
		}
		/**
		 * the maximum amount of frames a particle lives
		 */
		internal function set maxLive(value:int):void 
		{
			_maxLive = value;
		}
		/**
		 * returns a flag indicating if the source is attracting it's created particles
		 */
		public function get attr():Boolean 
		{
			return _attr;
		}
		/**
		 * the amount of power the source pulls its particles with,
		 * think of this as a spring constant, so usually between 0 and 1
		 */
		public function get attrFrc():Number 
		{
			return _attrFrc;
		}
		/**
		 * returns the color as a 32-bit color value
		 * @return
		 */
		public function getColor():uint 
		{
			return _color;
		}
		/**
		 * returns the source in a saveable format, in a string
		 * @return		the save format
		 */
		public function getSaveFormat():String
		{
			return String("s:" + x * PixelWorld.zoom + ":" + y * PixelWorld.zoom + ":" + _color + ":" + _t + ":" + _delay + ":" + _perFrame + ":" +
			((_cFromArr)?1: -1) + ":" + _cArray + ":" + ((_attr)?1: -1) + ":" + _attrFrc + ":" + _minLive +":" + _maxLive + ":" + ((_fade)?1: -1) +
			":" + ((_rotating)?1: -1) + ":" + _vr + ":" + _rot +":" + _maxVel +"\n");
		}
		
		////PUBLIC STATIC FUNCTION!!
		
		/**
		 * makes a source from a source saved format
		 * @param	frmt			the format
		 * @return		the source that is made
		 */
		public static function getSourceFromFormat(frmt:String):Source
		{
			var i:int = 0;
			i++;
			var lines:Array = frmt.split(":");
			var src:Source = new Source(parseInt((lines[i++]) as String), parseInt((lines[i++]) as String));
			i++;
			src.setColor(parseInt((lines[i] as String)));
			i++;
			var delay:int = parseInt((lines[i] as String));
			i++;
			var burst:int = parseInt((lines[i] as String));
			i++;
			src.setBurst(delay, burst);
			i++;
			if (parseInt((lines[i] as String)) > 0) {//if it uses from array colors
				var colors:Array = (lines[i] as String).split(",");
				var c:Array = [];
				var j:int, max:int = colors.length;
				for (j = 0; j < max; j++) {
					c[j] = parseInt(colors[j] as String);
				}
				src.setColorsFromArray(c);
			}else {
				i++;//skip this _color Array;
			}
			i++;
			if (parseInt((lines[i] as String)) > 0) {//if it uses attracting
				i++;
				src.setAttracting(parseFloat((lines[i] as String)));
			}else {
				i++;//skip this attracting power
			}
			i++;
			src._minLive = parseInt((lines[i] as String));
			i++;
			src._maxLive = parseInt((lines[i] as String));
			i++;
			var fading:Boolean = (parseInt((lines[i] as String)) > 0);
			src.setFadingParticles(fading);
			i++;
			if (parseInt((lines[i] as String)) > 0) {//if it uses attracting
				src.setRotating(parseFloat((lines[i++] as String)));
			}else {
				i++;//skip this attracting power
			}
			i++;
			src._rot = parseFloat(lines[i]);
			i++;
			var mSpeed:int = parseInt(lines[i]);
			src._maxVel = mSpeed;
			return src;
		}
		/**
		 * sets the position of this source. Calculates using worldzoom.
		 * @param	x		the x-coordinate
		 * @param	y		the y-coordinate
		 */
		public function setPos(x:Number, y:Number):void
		{
			var z:Number = _w.getZoom();
			this.x = x / z;
			this.y = y / z;
		}
		
	}

}