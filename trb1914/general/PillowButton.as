package trb1914.general 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * a class containing a basic button
	 * @author Mees Gelein
	 */
	public class PillowButton extends Sprite 
	{
		public static const ArialPlain12Black:TextFormat = new TextFormat("Arial", 12, 0x000000, false);
		public static const ArialPlain12White:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF, false);
		public static const ArialBold16Black:TextFormat = new TextFormat("Arial", 16, 0x000000, true);
		public static const ArialBold16White:TextFormat = new TextFormat("Arial", 16, 0xFFFFFF, true);
		public static const ArialBold24Black:TextFormat = new TextFormat("Arial", 24, 0x000000, true);
		public static const ArialBold24White:TextFormat = new TextFormat("Arial", 24, 0xFFFFFF, true);
		public static const ArialBold32Black:TextFormat = new TextFormat("Arial", 32, 0x000000, true);
		public static const ArialBold32White:TextFormat = new TextFormat("Arial", 32, 0xFFFFFF, true);
		private var _text:String;
		private var fadeSpeed:Number = 0.08;
		private var fadeAmount:Number = fadeSpeed;
		private var rotAmount:Number = 90 * fadeAmount;
		private var dying:Boolean = false;
		private var allowRotating:Boolean = true;
		private var allowScaling:Boolean = true;
		private var allowFading:Boolean = true;
		protected var _tf:TextField;
		protected var _icon:DisplayObject;
		/**
		 * makes a new pillow button, use the setText function or the setIcon for a graphics or
		 * text on the button. PillowButtons are always animated unless specified differently by
		 * the setAnimated(fading, scaling, rotating) method.
		 * @param	x			the x of the center of the button
		 * @param	y			the y of the center of the button
		 * @param	width		the width of the button
		 * @param	height		the height of the button
		 * @param	color		the color of the button in 24-bit color format
		 */
		public function PillowButton(x:Number, y:Number, width:Number, height:Number, color:uint)
		{
			this.x = x;
			this.y = y;
			drawMe(width, height, color);
			alpha = 0;
			rotation = -90;
			scaleX = scaleY = 0;
			addEventListener(Event.ENTER_FRAME, EF);
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
		}
		
		private function EF(e:Event):void 
		{
			if (allowFading) alpha += fadeAmount;
			if (allowScaling) { scaleX += fadeAmount; scaleY += fadeAmount; }
			if (allowRotating) rotation += rotAmount;
			
			if (alpha > 1) {
				alpha = 1;
				scaleX = 1;
				scaleY = 1;
				rotation = 0;
				removeEventListener(Event.ENTER_FRAME, EF);
			}else if (alpha < 0) {
				simpleDeath();
			}
			if (_tf != null) {
				_tf.x = -(_tf.width >> 1);
				_tf.y = -(_tf.height >> 1);
			}
		}
		/**
		 * sets an icon for the button. The icon can be any DisplayObject
		 * @param	icon			a image/movieclip/sprite or bitmap
		 */
		public function setIcon(icon:DisplayObject):void
		{
			if (_icon) removeChild(_icon);
			_icon = icon;
			if (_tf) removeChild(_tf);
			addChild(_icon);
			_icon.x = _icon.y = 0;
		}
		/**
		 * sets the text and the textformat.
		 * @param	text		the text on the button
		 * @param	txtFormat	the textformat, you can use constant from the PillowButton class
		 */
		public function setText(text:String, txtFormat:TextFormat):void
		{
			_text = text;
			if (_tf) removeChild(_tf);
			if (_icon) removeChild(_icon);
			_tf = new TextField();
			addChild(_tf);
			_tf.embedFonts = false;
			_tf.text = _text;
			_tf.selectable = false;
			_tf.setTextFormat(txtFormat);
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.x = -(_tf.width >> 1);
			_tf.y = -(_tf.height >> 1);
		}
		/**
		 * sets the animated style. Set all three to false to stop any animation
		 * @param	durationFrames  the amount of frames to get into existence and out of it
		 * @param	fading			if the button fades in and out of existence
		 * @param	scaling			if the button grows and shrinks out of existence
		 * @param	rotating		if the button rotates when created and destroyed
		 */
		public function setAnimated(durationFrames:int,fading:Boolean, scaling:Boolean = true, rotating:Boolean = true):void 
		{
			fadeSpeed = 1 / durationFrames;
			fadeAmount = fadeSpeed;
			rotAmount = fadeSpeed * 90;
			allowFading = fading;
			allowScaling = scaling;
			allowRotating = rotating;
			if (!fading) alpha = 1;
			if (!scaling) { scaleX = scaleY = 1; }
			if (!rotating) rotation = 0;
		}
		
		protected function onRollOut(e:MouseEvent):void 
		{
			alpha = 1;
		}
		
		protected function onRollOver(e:MouseEvent):void 
		{
			alpha = .8;
		}
		
		protected function drawMe(w:Number, h:Number, color:uint):void 
		{
			var g:Graphics = this.graphics;
			g.beginFill(color);
			g.lineStyle(4, 0, 0.3);
			g.drawRect( -(w >> 1), -(h >> 1), w, h);
			g.endFill();
			g.lineStyle(2, 0, 0.3);
			g.drawRect( -(w >> 1), -(h >> 1), w, h);
		}
		/**
		 * makes the button softly die, fading out of existence
		 */
		public function animatedDeath():void
		{
			fadeAmount = -fadeSpeed;
			rotAmount = 90 * fadeAmount;
			
			if (!dying) { addEventListener(Event.ENTER_FRAME, EF); dying = true; }
		}
		/**
		 * just removes the button and listeners
		 */
		public function simpleDeath():void {
			alpha = 0;
			removeEventListener(Event.ENTER_FRAME, EF);
			removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			if (this != null) parent.removeChild(this);
		}
	}

}