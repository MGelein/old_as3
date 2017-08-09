package  trb1914.verlet
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import trb1914.verlet.VBall;
	import trb1914.verlet.VObject;
	/**
	 * a class that manages all verlet objects added to this instance.
	 * @author Mees Gelein
	 */
	public class VWorld 
	{
		//some environmental vars
		internal var friction:Number = 0.99;
		private var _stageRect:Rectangle;
		internal var bounce:Number = -.6;
		
		//linked list stuff
		private var _headObj:VObject;
		private var _headAct:VActor;
		private var _actToRemove:Vector.<VActor> = new Vector.<VActor>();
		private var _objToRemove:Vector.<VObject> = new Vector.<VObject>();
		
		//drawing stuff
		private var _debugSprite:Sprite;
		private var _useDebugDraw:Boolean = false;
		
		//collission stufffff
		private var _collisionLoops:int = 2;
		/**
		 * creates a new instance of VWorld, the all knowing manager of
		 *  my verlet physics worlds
		 * @param	rect		the rect to keep objects alive in, if
		 * an object moves out of the rectangle, the object is removed from memory
		 */
		public function VWorld(rect:Rectangle) 
		{
			_stageRect = rect;
		}
		/**
		 * updates all the VObject and VActor instances and 
		 * resolves collisions, cleans list etc.
		 */
		public function update():void 
		{
			updateAll();
			cleanLists();
			var i:int, max:int = _collisionLoops;
			for (i = 0; i < max; i++) collision();
			constrain();
			if (_useDebugDraw) drawDebugData();
		}
		/**
		 * does the collision
		 */
		private function collision():void 
		{
			var obj:VObject = _headObj;
			var obj2:VObject;
			while (obj.next != null) {
				obj2 = obj.next
				while (obj2 != null) {
					if (obj.canMove || obj2.canMove) doCollision(obj, obj2);
					obj2 = obj2.next;
				}
				obj = obj.next;
			}
		}
		/**
		 * does a seperate collision with the two objects
		 * @param	obj			object 1
		 * @param	obj2		object 2
		 */
		private function doCollision(obj:VObject, obj2:VObject):void 
		{
			if (((obj.type == VObject.CIRCLE) && (obj2.type == VObject.CIRCLE)) && (obj.canMove && obj2.canMove)) {
				ccDynamicCollision(obj as VBall, obj2 as VBall);
			}else if ((obj.type == VObject.RECTANGLE) && (obj2.type == VObject.CIRCLE)) {
				cbCollision(obj2 as VBall, obj as VBox);
			}else if (((obj.type == VObject.CIRCLE) && (obj2.type == VObject.CIRCLE)) && (!obj.canMove)) {
				ccStaticCollision(obj as VBall, obj2 as VBall);
			}else if (((obj.type == VObject.CIRCLE) && (obj2.type == VObject.CIRCLE)) && (!obj2.canMove)) {
				ccStaticCollision(obj2 as VBall, obj as VBall);
			}else if ((obj.type == VObject.CIRCLE) && (obj2.type == VObject.RECTANGLE)) {
				cbCollision(obj as VBall, obj2 as VBox);
			}
		}
		/**
		 * handles static box with dynamic ball collision
		 * @param	ball			the ball
		 * @param	box				the static box
		 */
		private function cbCollision(ball:VBall, box:VBox):void
		{
			box.moveOutsideOfBox(ball);
		}
		/**
		 * handles a dynamic cirlce vs dynamic cirlce collision
		 * @param	ballStatic			the static ball
		 * @param	ballDynamic			the dynamic ball
		 */
		private function ccStaticCollision(ballStatic:VBall, ballDynamic:VBall):void
		{
			var dx:Number = ballDynamic.x - ballStatic.x;
			var dy:Number = ballDynamic.y - ballStatic.y;
			var totRadius:Number = ballStatic.radius + ballDynamic.radius;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			if (dist < totRadius) {
				var dif:Number = totRadius - dist;
				var angle:Number = Math.atan2(dy, dx);
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);			
				var x1:Number = ballDynamic.x - ballStatic.x;
				var y1:Number = ballDynamic.y - ballStatic.y;
				var ox1:Number = ballDynamic.ox - ballStatic.x;
				var oy1:Number = ballDynamic.oy - ballStatic.y;
				var x2:Number = cos * x1 + sin * y1;
				var y2:Number = cos * y1 - sin * x1;
				var ox2:Number = cos * ox1 + sin * oy1;
				var oy2:Number = cos * oy1 - sin * ox1;
				var vx:Number = ox2 - x2;
				x2 += dif;
				ox2 = x2 + vx * bounce;
				x2 += .1;//to counteract gravity?
				x1 = x2;
				y1 = y2;
				ox1 = ox2;
				oy1 = oy2;
				x2 = cos * x1 - sin * y1;
				y2 = cos * y1 + sin * x1;
				ox2 = cos * ox1 - sin * oy1;
				oy2 = cos * oy1 + sin * ox1;
				ballDynamic.x = x2 + ballStatic.x;
				ballDynamic.y = y2 + ballStatic.y;
				ballDynamic.ox = ox2 + ballStatic.x;
				ballDynamic.oy = oy2 + ballStatic.y;
			}
		}
		/**
		 * handles a dynamic cirlce vs dynamic cirlce collision
		 * @param	ballA		circle 1
		 * @param	ballB		circle 2
		 */
		private function ccDynamicCollision(ballA:VBall, ballB:VBall):void 
		{
			var dx:Number = ballA.x - ballB.x;
			var dy:Number = ballA.y - ballB.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			var totRadius:Number = ballA.radius + ballB.radius;
			if (dist < totRadius) {
				var dif:Number = (totRadius - dist);
				if (ballA.canMove && ballB.canMove) {
					var aprcnt:Number = ballA.radius / totRadius;
					var bprcnt:Number = 1 - aprcnt;
					ballA.x += dx / dist * dif * aprcnt;
					ballA.y += dy / dist * dif * aprcnt;
					ballB.x -= dx / dist * dif * bprcnt;
					ballB.y -= dy / dist * dif * bprcnt;
				}else if (ballA.canMove) {
					ballA.x += dx / dist * dif;
					ballA.y += dy / dist * dif;
				}else {
					ballB.x -= dx / dist * dif;
					ballB.y -= dy / dist * dif;
				}
			}
		}
		/**
		 * removes any object outside of the 'universe' XD
		 * CURRENTLY NOT WORKING!!
		 */
		private function constrain():void 
		{
			/*var o:VObject = _headObj;
			while (o != null) {
				if (o.canMove) o.constrain(_stageRect);
				o = o.next;
			}*/
		}
		/**
		 * updates all linked lists
		 */
		private function updateAll():void 
		{
			var o:VObject = _headObj;
			while (o != null) {
				if (o.canMove) o.update();
				o = o.next;
			}
			var a:VActor = _headAct;
			while (a != null) {
				a.update();
				a = a.next;
			}	
		}
		/**
		 * draws all the sprites with a graphics instance of the _canvas object
		 */
		private function drawDebugData():void
		{
			var o:VObject = _headObj;
			_debugSprite.graphics.clear();
			while (o != null) {
				o.draw(_debugSprite.graphics);
				o = o.next;
			}
		}
		/**
		 * cleans the list of all objects and actors marked for deletion
		 */
		private function cleanLists():void 
		{
			var i:int, max:int;
			if (_objToRemove.length > 0) {
				max = _objToRemove.length;
				var obj:VObject;
				for (i = 0; i < max; i++) {
					obj = _objToRemove[i];
					obj.prev.next = obj.next;
					obj.next.prev = obj.prev;
				}
				_objToRemove = new Vector.<VObject>();
			}
			if (_actToRemove.length > 0) {
				max = _actToRemove.length;
				var act:VActor;
				for (i = 0; i < max; i++) {
					act = _actToRemove[i];
					act.prev.next = act.next;
					act.next.prev = act.prev;
				}
				_actToRemove = new Vector.<VActor>();
			}
		}
		/**
		 * adds an object to the linked list of objects
		 * @param	obj			the actor to be added
		 */
		public function addObject(obj:VObject):void 
		{
			if (_headObj != null) {
				_headObj.prev = obj;
				obj.next = _headObj;
				_headObj = obj;
			}else {
				_headObj = obj;
			}
			obj.setWorld(this);
		}
		/**
		 * removes an object from the linked list of objects
		 * @param	obj			the object to be removed
		 */
		public function removeObject(obj:VObject):void 
		{
			_objToRemove[_objToRemove.length] = obj;		
		}
		/**
		 * adds an actor to the linked list of actors
		 * @param	act			the actor to be added
		 */
		public function addActor(act:VActor):void 
		{
			if (_headAct != null) {
				_headAct.prev = act;
				act.next = _headAct;
				_headAct = act;
			}else {
				_headAct = act;
			}
		}
		/**
		 * removes an actor from the linked list of actors
		 * @param	act			the actor to be removed
		 */
		public function removeActor(act:VActor):void 
		{
			_actToRemove[_actToRemove.length] = act;	
		}
		/**
		 * sets the debug drawing sprite to match this
		 * @param	dDraw		a new VDebug instance
		 */
		public function setDebugDrawSprite(sprite:Sprite):void
		{
			_debugSprite = sprite;
		}
		
		/*''''''''''''''''''''''*\
		 * GETTERS AND SETTERS	*|
		 *''''''''''''''''''''''*/
		
		/**
		 * the first VObject in the linked list of objects in the world
		 */
		internal function get headObj():VObject 
		{
			return _headObj;
		}		
		internal function set headObj(value:VObject):void 
		{
			_headObj = value;
		}
		/**
		 * the first VActor in the linked list of objects in the world
		 */
		public function get headAct():VActor 
		{
			return _headAct;
		}		
		public function set headAct(value:VActor):void 
		{
			_headAct = value;
		}
		/**
		 * a boolean flag indicating if the world also draws debug data.
		 * First however, you must have called setDebugDraw() with a new 
		 * instance of DebugDraw in it.
		 * Set this to true to draw or false to not draw
		 */
		public function get useDebugDraw():Boolean 
		{
			return _useDebugDraw;
		}		
		public function set useDebugDraw(value:Boolean):void 
		{
			_useDebugDraw = value;
		}
		
	}

}