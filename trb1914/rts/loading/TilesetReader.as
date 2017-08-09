package trb1914.rts.loading
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import trb1914.events.ImageEvent;
	import trb1914.general.ImageLoader;
	/**
	 * parses an xml file to load a tile set
	 * @author trb1914
	 */
	public class TilesetReader extends EventDispatcher
	{
		private var _tileBluePrints:Vector.<TileBluePrint>
		private var _xml:XML;
		private var _tileSet:Bitmap;
		private var _tileWidth:int;
		private var _tileHeigth:int;
		/**
		 * generates a new TileSetReader that reads 
		 * the xml file and loads the tileset.
		 * After loading it will have a vector of TileBluePrint's
		 * @param	tileSetXML
		 */
		public function TilesetReader(tileSetXML:XML) 
		{
			_xml = tileSetXML;
			_tileBluePrints = new Vector.<TileBluePrint>();
			var l:ImageLoader = new ImageLoader(_xml.tileImage);
			l.addEventListener(ImageEvent.COMPLETE, onComplete);
		}
		
		private function onComplete(e:ImageEvent):void 
		{
			_tileSet = e.image;
			sliceTiles();
		}
		
		private function sliceTiles():void 
		{
			var w:int = int(_xml.tileWidth);
			var h:int = int(_xml.tileHeight);
			_tileWidth = w; _tileHeigth = h;
			var cols:int = _tileSet.width / w;
			var rows:int = _tileSet.height / h;
			var srcData:BitmapData = _tileSet.bitmapData;
			var srcRect:Rectangle = new Rectangle(0, 0, w, h);
			var newData:BitmapData;
			var i:int, j:int, tileIndex:int = 0;
			for (i = 0; i < rows; i++ ) {
				srcRect.y = i * h;
				for (j = 0; j < cols; j++) {
					srcRect.x = j * w;
					tileIndex = i * cols + j;
					newData = new BitmapData(w, h, false);
					newData.copyPixels(srcData, srcRect, new Point());
					var walkAble:Boolean = (int(_xml.tile[tileIndex].walkAble) == 1);
					var cost:Number = Number(_xml.tile[tileIndex].cost);
					_tileBluePrints[_tileBluePrints.length] = new TileBluePrint(newData, walkAble, cost);
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * the width of each tile in pixels
		 */
		public function get tileWidth():int 
		{
			return _tileWidth;
		}
		/**
		 * the width of each tile in pixels
		 */
		public function set tileWidth(value:int):void 
		{
			_tileWidth = value;
		}
		/**
		 * the heigth of each tile in pixels
		 */
		public function get tileHeigth():int 
		{
			return _tileHeigth;
		}
		/**
		 * the heigth of each tile in pixels
		 */
		public function set tileHeigth(value:int):void 
		{
			_tileHeigth = value;
		}
		/**
		 * contains the tiles in a vector
		 */
		public function get tileBluePrints():Vector.<TileBluePrint> 
		{
			return _tileBluePrints;
		}
		/**
		 * contains the tiles in a vector
		 */
		public function set tileBluePrints(value:Vector.<TileBluePrint>):void 
		{
			_tileBluePrints = value;
		}
		
	}

}