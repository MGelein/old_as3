package trb1914.particleWorld
{
	/**
	 * a class for making colors
	 * @author Mees Gelein
	 */
	public class Color32 
	{
		public static const RED:uint = 0xFFFF0000;
		public static const DARK_RED:uint = 0xFFBB0000;
		public static const LIGHT_RED:uint = 0xFFFF5555;
		
		public static const BLUE:uint = 0xFF0000FF;
		public static const DARK_BLUE:uint = 0xFF0000BB;
		public static const LIGHT_BLUE:uint = 0xFF55CCFF;
		
		public static const GREEN:uint = 0xFF00FF00;
		public static const DARK_GREEN:uint = 0xFF00BB00;
		public static const LIGHT_GREEN:uint = 0xFF55FF55;
		
		public static const YELLOW:uint = 0xFFFFFF00;
		public static const DARK_YELLOW:uint = 0xFFBBBB00;
		public static const LIGHT_YELLOW:uint = 0xFFFFFF77;
		
		public static const MAGENTA:uint = 0xFFFF00FF;
		public static const DARK_MAGENTA:uint = 0xFFBB00BB;
		public static const LIGHT_MAGENTA:uint = 0xFFFF77FF;
		
		public static const CYAN:uint = 0xFF00FFFF;
		public static const DARK_CYAN:uint = 0xFF00BBBB;
		public static const LIGHT_CYAN:uint = 0xFF77FFFF;
		
		public static const PURPLE:uint = 0xFF7700FF;
		public static const DARK_PURPLE:uint = 0xFF5500BB;
		public static const LIGHT_PURPLE:uint = 0xFFBB66FF;
		
		public static const ORANGE:uint = 0xFFFF7700;
		public static const DARK_ORANGE:uint = 0xFFBB5500;
		public static const LIGHT_ORANGE:uint = 0xFFFFBB77;
		
		public static const WHITE:uint = 0xFFFFFFFF;
		public static const BLACK:uint = 0xFF000000;
		
		public static const GREY:uint = 0xFF999999;
		public static const LIGHT_GREY:uint = 0xFFBBBBBB;
		public static const DARK_GREY:uint = 0xFF555555;
		
		/**
		 * composes a 32-bit color from the given values
		 * @param	alpha		the alpha channel ranging from 0 to 255
		 * @param	red			the red channel ranging from 0 to 255
		 * @param	green		the green channel ranging from 0 to 255
		 * @param	blue		the blue channel ranging from 0 to 255
		 * @return				the composed color
		 */
		public static function compose(alpha:uint = 255, red:uint = 255, green:uint = 255, blue:uint = 255):uint
		{
			return alpha << 24 | red << 16 | green << 8 | blue;
		}
		/**
		 * decomposes any 32-bit color into its original alpha, red, green and blue channels.
		 * The result will be returned in an Array with the following indexing
		 * Array[0] = alpha channel;
		 * Array[1] = red channel
		 * Array[2] = green channel;
		 * Array[3] = blue channel
		 * @param	color32
		 * @return		a Array with seperate channels
		 */
		public static function decompose(color32:uint):Array
		{
			var a:uint = color32 >> 24 & 0xFF;
			var r:uint = color32 >> 16 & 0xFF;
			var g:uint = color32 >> 8 & 0xFF;
			var b:uint = color32 & 0xFF;
			var list:Array = [a, r, g, b];
			return list;
		}
		/**
		 * gives you an array with intermediate colors between two given colors in a 
		 * given number of steps
		 * @param	colorA		the first color to start with
		 * @param	colorB		the color to mix to
		 * @param	steps		the amount of steps we have to take to get to the 
		 * 						target color. This is also the amount of colors returned
		 * @return				an Array of colors with index of 0 being the start and 
		 * 						the last index the beginning
		 */
		public static function inBetween(colorA:uint, colorB:uint, steps:int = 10):Array
		{
			var colors:Array = [colorA];
			var channelsA:Array = decompose(colorA);
			var channelsB:Array = decompose(colorB);
			var channelDif:Array = [];
			var i:int; var max:int = 4; var multiplier:Number = 1 / (steps - 1);
			for (i = 0; i < max; i++) channelDif[i] = channelsB[i] - channelsA[i];
			for (i = 0; i < max; i++) channelDif[i] *= multiplier;
			var prevColor:uint;
			var prevChannels:Array = [];
			var a:uint, r:uint, g:uint, b:uint;
			for (i = 1; i < steps; i++) {
				prevColor = colors[i - 1];
				prevChannels = decompose(prevColor);
				a = prevChannels[0] + channelDif[0];
				r = prevChannels[1] + channelDif[1];
				g = prevChannels[2] + channelDif[2];
				b = prevChannels[3] + channelDif[3];
				colors[i] = compose(a, r, g, b);
			}
			return colors;
		}	
		/**
		 * turns any 32-bit color into an array with a 24-bit color and an alpha value.
		 * The Array has the following indexing
		 * Array[0] = color24;
		 * Array[1] = alpha;
		 * @param	color32		the color to turn into a 24-bit color and an alpha value
		 * @return				an Array with a 24-bit color and an alpha value
		 */
		public static function toColor24(color32:uint):Array
		{
			var channels:Array = Color32.decompose(color32);
			var list:Array = [Color24.compose(channels[1], channels[2], channels[3])];
			var alpha:Number = channels[0] / 255;
			list[1] = alpha;
			return list;
		}
		/**
		 * turns any 24-bit color and alpha value into an 32-bit color value
		 * @param	color24			the 24-bit color to convert
		 * @param	alpha			the alpha value to convert
		 * @return					the completed 32-bit color
		 */
		public static function toColor32(color24:uint, alpha:Number):uint
		{
			if (alpha > 1) alpha = 1;
			var a:uint = 255 * alpha;
			var channels:Array = Color24.decompose(color24);
			return Color32.compose(a, channels[0], channels[1], channels[2]);
		}
	}

}