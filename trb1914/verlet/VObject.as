package trb1914.verlet
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	/**
	 * a class containing a basic Verlet object
	 * @author Mees Gelein
	 */
	public class VObject 
	{
		public static const CIRCLE:int = 1;
		public static const RECTANGLE:int = 2;
		private var _type:int;
		private var _next:VObject;
		private var _prev:VObject;
		private var _x:Number;
		private var _y:Number;
		private var _rotation:Number = 0;
		private var _world:VWorld;
		private var _canMove:Boolean = true;
		/**
		 * creates a new VObject instance, with the following parameters:
		 * @param	x			the x-coordinate of the object
		 * @param	y			the y-coordinate of the object
		 * @param	type		the type of the object, can be: 
		 * VObject.CIRCLE or VObject.RECTANGLE
		 */
		public function VObject(x:Number, y:Number, type:int) 
		{
			_y = y;
			_x = x;	
			_type = type;
		}
		/**
		 * used internally to set a reference to the world
		 * @param	world
		 */
		internal function setWorld(world:VWorld):void
		{
			_world = world;
		}
		/**
		 * updates the object's position and takes care of the all 
		 * necessary updating. This method is empty by default and 
		 * needs to be overridden.
		 */
		public function update():void { }
		/**
		 * draws the object using the graphics of the given canvas object.
		 * Pass in a sprite's graphics property make the debug data be drawn
		 * on that sprite.
		 * This method is empty by default and needs to be overridden.
		 * @param	g			the graphics property to use
		 */
		public function draw(g:Graphics):void { }
		/**
		 * keeps the object within the boundaries of the world
		 * This method is empty by default and needs to be overridden.
		 * @param	rect			the boundaries of the world
		 */
		public function constrain(rect:Rectangle):void { }
		/**
		 * the current x-coordinate of the object
		 */
		public function get x():Number 
		{
			return _x;
		}		
		public function set x(value:Number):void 
		{
			_x = value;
		}
		/**
		 * the current y-coordinate of the object
		 */
		public function get y():Number 
		{
			return _y;
		}		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		/**
		 * the current rotation of the object measured in degrees
		 */
		public function get rotation():Number 
		{
			return _rotation;
		}		
		public function set rotation(value:Number):void 
		{
			_rotation = value;
		}
		/**
		 * a reference to the next VObject instance in the list,
		 * with null indicating the end of the list
		 */
		public function get next():VObject 
		{
			return _next;
		}		
		public function set next(value:VObject):void 
		{
			_next = value;
		}
		/**
		 * a reference to the previous VObject instance in the list,
		 * with null indicating the end of the list
		 */
		public function get prev():VObject 
		{
			return _prev;
		}		
		public function set prev(value:VObject):void 
		{
			_prev = value;
		}		
		/**
		 * the type of the object. It can be either VObject.CIRCLE or 
		 * VObject.RECTANGLE
		 */
		public function get type():int 
		{
			return _type;
		}		
		public function set type(value:int):void 
		{
			throw new Error("An object's type cannot be changed after object creation");
		}
		/**
		 * a reference to the world, can only be set by the world
		 */
		public function get world():VWorld 
		{
			return _world;
		}		
		public function set world(value:VWorld):void 
		{
			_world = value;
		}
		/**
		 * controlls if this object is allowed to move
		 */
		public function get canMove():Boolean 
		{
			return _canMove;
		}		
		public function set canMove(value:Boolean):void 
		{
			_canMove = value;
		}
		
	}

}