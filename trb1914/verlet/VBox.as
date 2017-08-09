package trb1914.verlet 
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import trb1914.verlet.VWorld;
	/**
	 * a class that makes up a box from VPoints and VSticks
	 * @author Mees Gelein
	 */
	public class VBox extends VObject 
	{
		private var _bounce:Number = -.6;
		private var _pts:Vector.<VPoint> = new Vector.<VPoint>(4, true);
		private var _jts:Vector.<VStick> = new Vector.<VStick>(6, true);
		private var _q:int;
		private const to_degrees:Number = 180 / Math.PI;
		private const to_radians:Number = Math.PI / 180;
		private var _hx:Number;
		private var _hy:Number;
		/**
		 * creates a new VBox instance with the following parameters: 
		 * @param	x			the x-coordinate of the object
		 * @param	y			the y-coordinate of the object
		 * @param	hx			the half-width of the object
		 * @param	hy			the half-height of the object
		 */
		public function VBox(x:Number, y:Number, hx:Number, hy:Number,stiffNess:int = 2) 
		{
			super(x, y, VObject.RECTANGLE);
			_hy = hy;
			_hx = hx;
			_pts[0] = new VPoint(x - hx, y - hy);
			_pts[1] = new VPoint(x + hx, y - hy);
			_pts[2] = new VPoint(x + hx, y + hy);
			_pts[3] = new VPoint(x - hx, y + hy);
			_jts[0] = new VStick(_pts[0], _pts[1]);
			_jts[1] = new VStick(_pts[1], _pts[2]);
			_jts[2] = new VStick(_pts[2], _pts[3]);
			_jts[3] = new VStick(_pts[3], _pts[0]);
			_jts[4] = new VStick(_pts[1], _pts[3]);
			_jts[5] = new VStick(_pts[0], _pts[2]);
			_q = stiffNess;
			canMove = false;
		}
		/**
		 * sets the world for this world and for all of it's points
		 * @param	world
		 */
		override internal function setWorld(world:VWorld):void 
		{
			_pts[0].setWorld(world);
			_pts[1].setWorld(world);
			_pts[2].setWorld(world);
			_pts[3].setWorld(world);
			super.setWorld(world);
		}
		/**
		 * updates all the joints and points
		 */
		override public function update():void 
		{
			var i:int, j:int;
			for (i = 0; i < 4; i++) { _pts[i].update(); _pts[i].y += .3; }
			for (j = 0; j < _q; j++) for (i = 0; i < 6; i++)_jts[i].update();
				
			var dx:Number = _pts[1].x - _pts[0].x;
			var dy:Number = _pts[1].y - _pts[0].y;
			x = (_pts[0].x + _pts[2].x) >> 1;
			y = (_pts[0].y + _pts[2].y) >> 1;
			rotation = Math.atan2(dy, dx) * to_degrees;
			super.update();
		}
		/**
		 * draws the box using the given graphics instance
		 * @param	g		the graphics property to use
		 */
		override public function draw(g:Graphics):void 
		{
			g.lineStyle(1, 0x00FF00, 0.8);
			g.beginFill(0x00FF00, 0.4);		
			g.moveTo(_pts[0].x, _pts[0].y);
			g.lineTo(_pts[1].x, _pts[1].y);
			g.lineTo(_pts[2].x, _pts[2].y);
			g.lineTo(_pts[3].x, _pts[3].y);
			g.lineTo(_pts[0].x, _pts[0].y);
			g.endFill();
			super.draw(g);
		}
		/**
		 * keeps the box in the 'universe'
		 * @param	rect		the rectangle to keep it in
		 */
		override public function constrain(rect:Rectangle):void 
		{
			var i:int, j:int;
			for (j = 0; j < _q; j++) for (i = 0; i < 4; i++) _pts[i].constrain(rect);
			super.constrain(rect);
		}
		/**
		 * moves any ball out of the box, but first checks if it's near
		 * @param	p			the ball to move if it's a collision
		 */
		internal function moveOutsideOfBox(p:VBall):void
		{
			var dx:Number = _pts[1].x - _pts[0].x;
			var dy:Number = _pts[1].y - _pts[0].y;
			var angle:Number = Math.atan2(dy, dx)
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			var cX:Number = x;
			var cY:Number = y;
			var x1:Number = p.x - x;
			var y1:Number = p.y - y;
			var ox1:Number = p.ox - x;
			var oy1:Number = p.oy - y;
			var x2:Number = cos * x1 - sin * y1;
			var y2:Number = cos * y1 + sin * x1;
			var ox2:Number = cos * ox1 - sin * oy1;
			var oy2:Number = cos * oy1 + sin * ox1;
			p.x = x2 + cX;
			p.y = y2 + cY;
			p.ox = ox2 + cX;
			p.oy = oy2 + cY;
			if ((p.x - p.radius < cX + _hx) && (p.x + p.radius > cX - _hx)) {
				if ((p.y - p.radius  < cY + _hy) && (p.y + p.radius > cY - _hy)) {
					moveOutOfHere(p, cX, cY);
				}
			}
			x1 = p.x - cX;
			y1 = p.y - cY;
			ox1 = p.ox - x;
			oy1 = p.oy - y;
			ox2 = cos * ox1 + sin * oy1;
			oy2 = cos * oy1 - sin * ox1;
			x2 = cos * x1 + sin * y1;
			y2 = cos * y1 - sin * x1;
			p.x = x2 + cX;
			p.y = y2 + cY;
			p.ox = ox2 + cX;
			p.oy = oy2 + cY;
		}
		/**
		 * moves the ball away after having established that neither x or y axis seperates
		 * the objects
		 * @param	p			the ball
		 * @param	cX			the center x
		 * @param	cY			the center y
		 */	
		private function moveOutOfHere(p:VBall, cX:Number, cY:Number):void
		{
			var ptDx:Number = (cX - _hx) - p.x;
			var ptDy:Number = (cY - _hy) - p.y;
			var pt1Axis:VCollisionAxis = new VCollisionAxis(ptDx, ptDy);
			ptDx = (cX + _hx) - p.x;
			ptDy = (cY - _hy) - p.y;
			var pt2Axis:VCollisionAxis = new VCollisionAxis(ptDx, ptDy);
			ptDx = (cX + _hx) - p.x;
			ptDy = (cY + _hy) - p.y;
			var pt3Axis:VCollisionAxis = new VCollisionAxis(ptDx, ptDy);
			ptDx = (cX - _hx) - p.x;
			ptDy = (cY + _hy) - p.y;
			var pt4Axis:VCollisionAxis = new VCollisionAxis(ptDx, ptDy);
			var shortestAxis:VCollisionAxis = pt1Axis;
			shortestAxis = (shortestAxis.length > pt2Axis.length) ? pt2Axis:shortestAxis;
			shortestAxis = (shortestAxis.length > pt3Axis.length) ? pt3Axis:shortestAxis;
			shortestAxis = (shortestAxis.length > pt4Axis.length) ? pt4Axis:shortestAxis;
			var shortestR:Number = shortestAxis.length;			
			var shortestX:Number = 0;
			var shortestY:Number = 0;
			var dx1:Number = (cX + _hx) - p.x + p.radius;
			var dx2:Number = (cX - _hx) - p.x - p.radius;
			if (Math.abs(dx1) < Math.abs(dx2)) shortestX = dx1;
			else shortestX = dx2;
			var dy1:Number = (cY + _hy) - p.y + p.radius;
			var dy2:Number = (cY - _hy) - p.y - p.radius;
			if (Math.abs(dy1) < Math.abs(dy2)) shortestY = dy1;
			else shortestY = dy2;
			shortestR = shortestAxis.length - p.radius;
			if ((Math.abs(shortestX) < Math.abs(shortestY))&&(Math.abs(shortestX) < shortestAxis.length)) {
				var dx:Number = p.x - p.ox;
				p.x += shortestX;
				p.ox = p.x - dx * _bounce;
			}else if ((Math.abs(shortestY) < Math.abs(shortestX)) && (Math.abs(shortestY) < shortestAxis.length)) {
				var dy:Number = p.y - p.oy;
				p.y += shortestY;
				p.oy = p.y - dy * _bounce;
			}else {//radius
				shortestAxis.length = shortestAxis.length - p.radius;
				p.x += shortestAxis.dx;
				p.y += shortestAxis.dy;
			}
		}
		/**
		 * gets/sets the rotation, keeps the force and torque
		 */
		override public function get rotation():Number 
		{
			return super.rotation;
		}
		/**
		 * gets/sets the rotation in degrees
		 */
		override public function set rotation(value:Number):void 
		{
			_pts[0].x = x - _hx;
			_pts[0].y = y - _hy;
			_pts[1].x = x + _hx;
			_pts[1].y = y - _hy;
			_pts[2].x = x + _hx;
			_pts[2].y = y + _hy;
			_pts[3].x = x - _hx;
			_pts[3].y = y + _hy;
			var dr:Number = value * to_radians;
			var sin:Number = Math.sin(dr);
			var cos:Number = Math.cos(dr);
			var i:int, max:int = 4, cPt:VPoint;
			var dx1:Number, dy1:Number, x2:Number, y2:Number;
			for (i = 0; i < max; i++) {
				cPt = _pts[i];
				dx1 = cPt.x - x;
				dy1 = cPt.y - y;
				x2 = cos * dx1 - sin * dy1;
				y2 = cos * dy1 + sin * dx1;
				cPt.x = x2 + x;
				cPt.y = y2 + y;
				cPt.setPos(cPt.x, cPt.y);
			}			
			super.rotation = -value;
		}
		/**
		 * set the rotation in degrees without any remaining forces
		 * @param	value		the angle in degrees
		 */
		public function setRotation(value:Number):void
		{
			rotation = value;
			var i:int, max:int = 4;
			for (i = 0; i < max ; i++) {
				_pts[i].setPos(_pts[i].x, _pts[i].y);
			}
		}
		/**
		 * sets the amount of energy lost in a collision. A number between
		 * -1 and 0. With -1 being an elastic collision and 0 being total
		 * energy loss. Defaults to -0.6;
		 * @param	bounce		the bounce value
		 */
		public function setBounce(bounce:Number):void
		{
			_bounce = bounce;		
		}
		/**
		 * the amount of energy lost in a collision. A number between
		 * -1 and 0. With -1 being an elastic collision and 0 being total
		 * energy losss
		 */
		public function getBounce():Number
		{
			return _bounce;
		}
		/**
		 * the x coordinate of this box, change this to move the box
		 */
		override public function get x():Number 
		{
			return super.x;
		}
		/**
		 * the x coordinate of this box, change this to move the box
		 */
		override public function set x(value:Number):void 
		{
			var dx:Number = x - value;
			_pts[0].x -= dx;
			_pts[1].x -= dx;
			_pts[2].x -= dx;
			_pts[3].x -= dx;
			super.x = value;
		}
		
		/**
		 * the y coordinate of this box, change this to move the box
		 */
		override public function get y():Number 
		{
			return super.y;
		}
		/**
		 * the y coordinate of this box, change this to move the box
		 */
		override public function set y(value:Number):void 
		{
			var dy:Number = y - value;
			_pts[0].y -= dy;
			_pts[1].y -= dy;
			_pts[2].y -= dy;
			_pts[3].y -= dy;
			super.y = value;
		}
	}

}