package trb1914.rts.loading 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author trb1914
	 */
	public class TileBluePrint 
	{
		public var image:BitmapData;
		public var walkAble:Boolean;
		public var cost:Number;
		public function TileBluePrint(img:BitmapData, walkAble:Boolean, cost:Number = 1)
		{
			image = img;
			this.walkAble = walkAble;
			this.cost = cost;
		}
		
	}

}