package trb1914.particleWorld.particle3d 
{
	import trb1914.general.Point3D;
	import trb1914.particleWorld.Color32;
	/**
	 * ...
	 * @author trb1914
	 */
	public class Particle3D 
	{
		private var _pos:Point3D;
		private var _vel:Point3D;
		private var _x:Number;
		private var _y:Number;
		private var _c:uint;
		public function Particle3D(pos:Point3D, color:uint = Color32.RED) 
		{
			_pos = pos; _c = color;
		}
		
		public function update():void
		{
			
		}
		/**
		 * the screen x-coordinate
		 */
		public function get x():Number 
		{
			return _x;
		}
		/**
		 * the screen y-coordinate
		 */
		public function get y():Number 
		{
			return _y;
		}
		/**
		 * the color in a 32-bit color format
		 */
		public function get c():uint 
		{
			return _c;
		}
		
	}

}