package trb1914.verlet 
{
	import flash.display.Graphics;
	/**
	 * a extension of the VPoint class, a simple ball
	 * @author Mees Gelein
	 */
	public class VBall extends VPoint 
	{
		public static const STATIC_COLOR:uint = 0x00FF00;
		public static const DYNAMIC_COLOR:uint = 0xFF0000;
		private var _c:uint;
		/**
		 * creates a new VBall instance, which is essentially a VPoint with gravity
		 * and a radius which you can set
		 * @param	x			the x of the newly created circle's center
		 * @param	y			the y of the newly created circle's center
		 * @param	radius		the radius of the newly created circle
		 */
		public function VBall(x:Number, y:Number, radius:Number) 
		{
			super(x, y);
			this.radius = radius;
			_c = (canMove) ? DYNAMIC_COLOR:STATIC_COLOR;
		}
		/**
		 * updates the ball and handles gravity
		 */
		override public function update():void 
		{
			super.update();
			y += .3;
		}
		/**
		 * draws the current ball with the given graphics instance
		 * @param	g
		 */
		override public function draw(g:Graphics):void 
		{
			g.lineStyle(1, _c, 0.8);
			g.beginFill(_c, 0.4);
			g.drawCircle(x, y, radius);
			g.endFill();
			super.draw(g);
		}
		/**
		 * controlls if this object is allowed to move and changes it's color
		 */
		override public function get canMove():Boolean 
		{
			return super.canMove;
		}
		/**
		 * controlls if this object is allowed to move and changes it's color
		 */
		override public function set canMove(value:Boolean):void 
		{
			super.canMove = value;
			_c = (canMove) ? DYNAMIC_COLOR:STATIC_COLOR;
		}
		
	}

}