package trb1914.verlet 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * a class that spans the bridge between the Verlet instances and
	 * the actual display object world of AS 3.0
	 * @author Mees Gelein
	 */
	public class VActor 
	{
		private var _next:VActor;
		private var _prev:VActor;
		private var _obj:VObject;
		private var _img:Sprite;
		/**
		 * creates a new VActor instance, with the following parameters
		 * @param	parent			the parent object to add the sprite to
		 * @param	vObj			the object to mimic
		 * @param	sprite			the sprite that mimics the movement of the VObject
		 */
		public function VActor(parent:DisplayObjectContainer, object:VObject, sprite:DisplayObject)
		{
			_obj = object;
			_img = new Sprite();
			_img.addChild(sprite);
			parent.addChild(_img);
			update();
		}
		/**
		 * this method positions the sprite at the location of the VObject
		 * and also calls the extraUpdate() method.
		 * use the extraUpdate method to do your own updating
		 * Note: this method can't be overridden
		 */
		final public function update():void
		{
			extraUpdate();
			_img.x = _obj.x;
			_img.y = _obj.y;
			_img.rotation = _obj.rotation;			
		}
		/**
		 * an empty method, only used for overriding
		 */
		protected function extraUpdate():void { }
		/**
		 * a reference to the next VActor instance in the list,
		 * with null indicating the end of the list
		 */
		public function get next():VActor 
		{
			return _next;
		}		
		public function set next(value:VActor):void 
		{
			_next = value;
		}
		/**
		 * a reference to the previous VActor instance in the list,
		 * with null indicating the end of the list
		 */
		public function get prev():VActor 
		{
			return _prev;
		}		
		public function set prev(value:VActor):void 
		{
			_prev = value;
		}
		
	}

}