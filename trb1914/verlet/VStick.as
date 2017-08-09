package trb1914.verlet 
{
	import flash.display.Graphics;
	/**
	 * a class containing a simple way to keep two point together
	 * @author Mees Gelein
	 */
	public class VStick 
	{
		private var _ptA:VPoint;
		private var _ptB:VPoint;
		private var _wl:Number;
		/**
		 * creates a new VStick instance with the following parameters:
		 * @param	ptA				the first point
		 * @param	ptB				the second point
		 * @param	length			optional: wanted length, leave at -1 to
		 * set it automatticaly
		 */
		public function VStick(ptA:VPoint, ptB:VPoint, length:Number = -1)
		{
			_ptB = ptB;
			_ptA = ptA;
			if (length == -1) {
				var dx:Number = ptA.x - ptB.x;
				var dy:Number = ptA.y - ptB.y;
				_wl = Math.sqrt(dx * dx + dy * dy);
			}else {
				_wl = length;
			}
		}
		/**
		 * keeps the two points together
		 */
		public function update():void
		{
			var dx:Number = _ptA.x - _ptB.x;
			var dy:Number = _ptA.y - _ptB.y;
			var l:Number = Math.sqrt(dx * dx + dy * dy);
			var dif:Number = (l - _wl) >> 1;
			var ofX:Number = dx / l * dif;
			var ofY:Number = dy / l * dif;
			_ptA.x -= ofX;
			_ptA.y -= ofY;
			_ptB.x += ofX;
			_ptB.y += ofY;
		}
		/**
		 * draws the current stick
		 * @param	g		the graphics instance to draw it on
		 */
		public function draw(g:Graphics):void
		{
			g.lineStyle(1);
			g.moveTo(_ptA.x, _ptA.y);
			g.lineTo(_ptB.x, _ptB.y);
			g.lineStyle();
		}
		
	}

}