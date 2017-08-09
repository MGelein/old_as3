package trb1914.general 
{
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * a class that has an enterFrame listener an it updates things with an update method.
	 * To put it better, that implement the IUpdate interface
	 * @author Mees Gelein
	 */
	public class EnterFrameList extends Shape 
	{
		private var toUpdate:Vector.<IUpdate> = new Vector.<IUpdate>();
		private var toRemove:Vector.<IUpdate> = new Vector.<IUpdate>();
		/**
		 * creates a new EnterFramelist with some optional starting instances
		 * @param	initialInstances		optional, some starting instances to begin
		 * 									the list with
		 */
		public function EnterFrameList(initialInstances:Vector.<IUpdate> = null) 
		{
			if (initialInstances != null) toUpdate = initialInstances;
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			var i:int, max:int = toUpdate.length;
			for (i = 0; i < max; i++) toUpdate[i].update();
			max = toRemove.length;
			if (max > 0) {
				for (i = 0; i < max; i++) {
					var index:int = toUpdate.indexOf(toRemove[i], 0);
					if (index != -1) {
						toUpdate.splice(index, 1);
					}
				}
				toRemove = new Vector.<IUpdate>();
			}
		}
		/**
		 * adds a member (someone that implements the IUpdate interface) to the update list
		 * @param	member			the member to add
		 */
		public function addMember(member:IUpdate):void
		{
			toUpdate[toUpdate.length] = member;
		}
		/**
		 * removes a member (someone that implements the IUpdate interface) from the update list
		 * @param	member			the member to remove
		 */
		public function removeMember(member:IUpdate):void
		{
			toRemove[toRemove.length] = member;
		}
		/**
		 * starts the enterframe listener
		 */
		public function start():void
		{
			stop();
			addEventListener(Event.ENTER_FRAME, update);
		}
		/**
		 * stops the enterframe listener, effectively pausing all movement
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}		
	}

}