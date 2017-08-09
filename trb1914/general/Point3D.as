package  trb1914.general
{
	/**
	 * ...
	 * @author Mees
	 */
	public class Point3D 
	{
		public var fl:Number = 250;
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public static var vpx:Number = 0;
		public static var vpy:Number = 0;
		private var cX:Number = 0;
		private var cY:Number = 0;
		private var cZ:Number = 0;
		
		public static function setVP(x:Number, y:Number):void
		{
			vpx = x; vpy = y;
		}
		
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0 ) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function setVanishingPoint(vpx:Number, vpy:Number):void {
			this.vpx = vpx;
			this.vpy = vpy;
		}
		
		public function setCenter(cX:Number, cY:Number, cZ:Number = 0):void {
			this.cX = cX;
			this.cY = cY;
			this.cZ = cZ;
		}
		
		public function getScreenX():Number {
			var scale:Number = fl / (fl + z + cZ);
			return vpx + (cX + x) * scale;
		}
		
		public function getScreenY():Number {
			var scale:Number = fl / (fl + z + cZ);
			return vpy + (cY + y) * scale;
		}
		
		public function rotateX(angle:Number):void {
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			var y1:Number = y * cos - z * sin;
			var z1:Number = z * cos + y * sin;
			
			y = y1;
			z = z1;
		}
		
		public function rotateY(angle:Number):void {
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			var x1:Number = x * cos - z * sin;
			var z1:Number = z * cos + x * sin;
			
			x = x1;
			z = z1;
		}
		
		public function rotateZ(angle:Number):void {
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			var x1:Number = x * cos - y * sin;
			var y1:Number = y * cos + x * sin;
			
			x = x1;
			y = y1;
		}
		
		
	}

}