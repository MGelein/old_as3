package  trb1914.general
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class GlassButton extends Sprite 
	{
		private var darker:Number = 0.8;
		private var offsetY:Number;
		private var offsetX:Number;
		private var _growRatio:Number = 0.05;
		private var _ignoreMouse:Boolean = false;
		
		/**
		 * 
		 * @param	x			The x-position of the glassButton
		 * @param	y			The y-position of the glassButton
		 * @param	width		The width of the button in pixels
		 * @param	height		The height of the button in pixels
		 * @param	color32		The color of the button in 32-bit color
		 * @param	curve		The curve-radius in pixels
		 */
		
		public function GlassButton(x:Number, y:Number, width:Number, height:Number, color32:uint, curve:int = 10 ) 
		{
			this.x = x;
			this.y = y;
			
			var alpha:uint = color32 >> 24;
			var red:uint = color32 >> 16 & 0xFF;
			var green:uint = color32 >> 8 & 0xFF;
			var blue:uint = color32 & 0xFF;
			var color24B:uint = red * darker << 16 | green * darker << 8 | blue * darker;
			var color24A:uint = red << 16 | green << 8 | blue;
			var wantedAlpha:Number = alpha / 255;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, Math.PI * .5);
			var colors:Array = [color24A, color24B];
			var alphas:Array = [wantedAlpha, wantedAlpha];
			var ratios:Array = [0, 255];
			var g:Graphics = this.graphics;
			var fillType:String = GradientType.LINEAR;
			g.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			g.drawRoundRect(0, 0, width, height, curve, curve);
			g.endFill();
			
			//drawing the shine
			matrix.createGradientBox(width, height, Math.PI * .5, 0, -height * .3);
			colors = [0xFFFFFF, 0xFFFFFF];
			alphas = [0.6, 0];
			ratios = [0, 255]; 
			g.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			var left:Number = curve * .3;
			var top:Number = curve * .3;
			var right:Number = width - curve * .3;
			var bottom:Number = height * .5 - curve * .3;
			g.moveTo(left, top);
			g.lineTo(left, bottom);
			g.curveTo(width * .5, bottom + 4 * top, right, bottom);
			g.lineTo(right, top);
			g.lineTo(left, top);
			g.endFill();
			
			offsetY = height * (_growRatio * .5);
			offsetX = width * (_growRatio * .5);
			
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
		}
		
		protected function onRollOut(e:MouseEvent):void 
		{
			if (!_ignoreMouse) {
				alpha = 1;
				scaleX = scaleY = 1;
				y -= offsetY;
				x += offsetX;
			}			
		}
		
		protected function onRollOver(e:MouseEvent):void 
		{
			if (!_ignoreMouse) {
				alpha = 0.8;
				scaleX = scaleY = 1 + growRatio;
				y += offsetY;
				x -= offsetX;
			}			
		}
		/**
		 * removing all event listeners, so that you can savely remove the button
		 */
		
		public function removeMe():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);		
		}
		
		/**
		 * the growRatio determines how much the button grows. A value of 0.1 will make the buttonscale to 1.1
		 */		
		public function get growRatio():Number 
		{
			return _growRatio;
		}
		
		/**
		 * the growRatio determines how much the button grows. A value of 0.1 will make the buttonscale to 1.1
		 */
		
		public function set growRatio(value:Number):void 
		{
			_growRatio = value;
			offsetY = height * (_growRatio * .5);
			offsetX = width * (_growRatio * .5);
			
		}
		/**
		 * if set to true, you can make the button ignore any mouse roll overs
		 * or a roll out or clicks.
		 */
		public function get ignoreMouse():Boolean 
		{
			return _ignoreMouse;
		}
		/**
		 * if set to true, you can make the button ignore any mouse roll overs
		 * or a roll out or clicks.
		 */
		public function set ignoreMouse(value:Boolean):void 
		{
			_ignoreMouse = value;
		}
		
	}

}