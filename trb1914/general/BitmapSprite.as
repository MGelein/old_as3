package trb1914.general 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * a class used to easily add embedded pictures to a sprite
	 * @author Mees Gelein
	 */
	public class BitmapSprite extends Sprite 
	{
		private var graphic:Bitmap;
		/**
		 * makes a new BitmapSprite
		 * @param	parent				the parent to add the sprite to
		 * @param	graphicsClass		the class of the graphic to use
		 */
		public function BitmapSprite(parent:DisplayObjectContainer, graphicsClass:Class) 
		{
			parent.addChild(this);
			addChild(graphic = new graphicsClass() as Bitmap);
		}
		/**
		 * use this to replace pictures with another
		 * @param	graphicsClass
		 */
		public function changeGraphic(graphicsClass:Class)
		{
			if (graphic != null) removeChild(graphic);
			addChild(graphic = new graphicsClass() as Bitmap);			
		}
		/**
		 * removes this instance from the displayList
		 */
		public function removeMe():void
		{
			if (parent != null) parent.removeChild(this);
		}
		/**
		 * removes the graphics of this sprite from the displaylist
		 */
		public function deleteGraphic():void
		{
			if (graphic != null) removeChild(graphic);
		}
		/**
		 * centers the graphic, so that the graphics center is on the 0,0 of the sprite
		 */
		public function centerGraphic():void 
		{
			graphic.x = -graphic.width * .5;
			graphic.y = -graphic.height * .5;
		}
		/**
		 * puts the graphic on the given position, in relation to the 0,0 of the sprite
		 * @param	x			the x-coordinate of the place to put it
		 * @param	y			the y-coordinate of the place to put it
		 */
		public function positionGraphic(x:Number, y:Number):void
		{
			graphic.x = x;
			graphic.y = y;
		}
		
	}

}