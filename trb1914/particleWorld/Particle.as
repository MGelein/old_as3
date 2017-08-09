package trb1914.particleWorld 
{
	import flash.geom.Rectangle;
	import trb1914.particleWorld.Color32;
	/**
	 * a basic particle class
	 * @author Mees Gelein
	 */
	public class Particle
	{
		internal static var BNCE:Number = -.6;
		private var _x:Number;
		private var _y:Number;
		private var _vx:Number;
		private var _vy:Number;
		private var _c:uint;
		private var _src:Source;
		private var _a:int = 0;
		private var _l:int;
		private var _fading:Boolean = false;
		private var _l2:Number;
		private var _fadeAmnt:Number;
		private var _n:Particle = null;
		private var _p:Particle = null;
		private var _b:ParticleBounds;
		private var vx1:Number;
		private var vy1:Number;
		private var rInt:Number;
		private var channels:Array;
		/**
		 * makes a new particle
		 * @param	x			the x-coordinate in the particleworld to create it at
		 * @param	y			the y-coordinate in the particleworld to create it at
		 * @param	color		the 32-bit color to paint the particle
		 */
		public function Particle(x:Number, y:Number, color:uint, src:Source) 
		{
			_x = x; _vx = _vy = 0;_y = y;
			_c = color;	
			_l = PixelWorld.random() * src.maxLive + src.minLive;
			_l2 = _l * .5;
			_fadeAmnt = 255 / _l2;
			this.src = src;
			_b = PixelWorld.SCREEN;
		}
		/**
		 * gives the particle a random speed limited by a maximum speed
		 * @param	max				the maximum speed allowed for the particle
		 */
		public function setRandomSpeed(max:Number):void
		{
			var max2:Number = max * .5;
			_vx = PixelWorld.random() * max - max2;
			_vy = PixelWorld.random() * max - max2;
		}
		/**
		 * sets the particles speed in a certain direction at a certain velocity
		 * @param	rotation			the direction of the particle
		 * @param	speed				the speed of the particle
		 */
		public function setAngVel(rotation:Number, speed:Number):void
		{
			var a:Number = speed * PixelWorld.random();
			rotation *= PixelWorld.TO_RADIANS;
			_vx = Math.cos(rotation) * a;
			_vy = Math.sin(rotation) * a;
		}
		/**
		 * moves the particle and fades, bounces or attracts the particle where 
		 * needed
		 * @param	dt			optional time interval, with 1 being 1 frame
		 */
		public function update(dt:Number = 1):void
		{
			_x += _vx * dt;
			_y += _vy * dt;
			vx1 = _vx * PixelWorld.FRICTION;
			vy1 = _vy * PixelWorld.FRICTION;
			rInt = 1 - dt;
			_vx = vx1 * dt + _vx * rInt;
			_vy = vy1 * dt + _vy * rInt;
			_vx += PixelWorld.GRAVITY.x * dt;
			_vy += PixelWorld.GRAVITY.y * dt;
			
			if (PixelWorld.BOUNDS_ON) {
				if (_x > _b.r) {
					_x = _b.r;
					_vx *= BNCE * PixelWorld.random();
				}else if (_x < _b.l) {
					_x = _b.l;
					_vx *= BNCE * PixelWorld.random();
				}if (_y < _b.t) {
					_y = _b.t;
					_vy *= BNCE * PixelWorld.random();
				}else if (_y > _b.b) {
					_y = _b.b;
					_vy *= BNCE * PixelWorld.random();
				}
			}else {
				_x = (_x > _b.r) ? die() : _x;
				_x = (_x < _b.l) ? die(): _x;
				_y = (_y < _b.t) ? die(): _y;
				_y = (_y > _b.b) ? die(): _y;
			}
			
			if (src) {
				if (src.attr) {
					_vx += (src.x - _x) * src.attrFrc * dt;
					_vy += (src.y - _y) * src.attrFrc * dt;
				}
			}
			
			_a += dt;
			if (_a > _l2) {
				if (_fading) {
					channels = Color32.decompose(_c);
					channels[0] -= _fadeAmnt * dt;
					_c = Color32.compose(channels[0], channels[1], channels[2], channels[3]);
				}
				if (_a > _l) die();
			}
			
			var a:ParticleAttractor = PixelWorld.headAttr;
			var dx:Number, dy:Number, force:Number;
			while (a != null) {
				dx = a.x - _x;
				dy = a.y - _y;
				if (dx * dx + dy * dy < (a.strength * a.strength) * 200) {
					_vx += dx * a.strength * dt;
					_vy += dy * a.strength * dt;
				}
				a = a.next;
			}
		}
		/**
		 * removes the particle
		 */
		private function die():int 
		{
			PixelWorld.removeParticle(this);
			return -10;
		}
		
		/////////////////////////////////
		//	GETTERS AND SETTERS
		/////////////////////////////////
		
		/**
		 * the color of the particle in a 32-bit color format
		 */
		public function get c():uint 
		{
			return _c;
		}
		/**
		 * the color of the particle in a 32-bit color format
		 */
		public function set c(value:uint):void 
		{
			_c = value;
		}
		/**
		 * the y-coordinate of the particle in the world-coordinate space
		 */
		public function get y():Number 
		{
			return _y;
		}
		/**
		 * the y-coordinate of the particle in the world-coordinate space
		 */
		public function set y(value:Number):void 
		{
			_y = value;
		}
		/**
		 * the x-coordinate of the particle in the world-coordinate space
		 */
		public function get x():Number 
		{
			return _x;
		}
		/**
		 * the x-coordinate of the particle in the world-coordinate space
		 */
		public function set x(value:Number):void 
		{
			_x = value;
		}
		/**
		 * the source of this particle
		 */
		public function get src():Source 
		{
			return _src;
		}
		/**
		 * the source of this particle
		 */
		public function set src(value:Source):void 
		{
			_src = value;
		}
		/**
		 * if this particle will fade over time
		 */
		public function get fading():Boolean 
		{
			return _fading;
		}
		/**
		 * if this particle will fade over time
		 */
		public function set fading(value:Boolean):void 
		{
			_fading = value;
		}
		/**
		 * the next element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		public function get nxt():Particle 
		{
			return _n;
		}
		/**
		 * the next element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		public function set nxt(value:Particle):void 
		{
			_n = value;
		}
		/**
		 * the last element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		public function get last():Particle 
		{
			return _p;
		}
		/**
		 * the last element in the linked list. If this is null, 
		 * that indicates the end of the list.
		 */
		public function set last(value:Particle):void 
		{
			_p = value;
		}
		
	}

}