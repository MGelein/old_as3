package trb1914.particleWorld 
{
	/**
	 * a class containing some methods for 24-bit color values
	 * @author Mees Gelein
	 */
	public class Color24
	{
		public static const RED:uint = 0xFF0000;
		public static const DARK_RED:uint = 0xBB0000;
		public static const LIGHT_RED:uint = 0xFF5555;
		
		public static const BLUE:uint = 0x0000FF;
		public static const DARK_BLUE:uint = 0x0000BB;
		public static const LIGHT_BLUE:uint = 0x55CCFF;
		
		public static const GREEN:uint = 0x00FF00;
		public static const DARK_GREEN:uint = 0x00BB00;
		public static const LIGHT_GREEN:uint = 0x55FF55;
		
		public static const YELLOW:uint = 0xFFFF00;
		public static const DARK_YELLOW:uint = 0xBBBB00;
		public static const LIGHT_YELLOW:uint = 0xFFFF77;
		
		public static const MAGENTA:uint = 0xFF00FF;
		public static const DARK_MAGENTA:uint = 0xBB00BB;
		public static const LIGHT_MAGENTA:uint = 0xFF77FF;
		
		public static const CYAN:uint = 0x00FFFF;
		public static const DARK_CYAN:uint = 0x00BBBB;
		public static const LIGHT_CYAN:uint = 0x77FFFF;
		
		public static const PURPLE:uint = 0x7700FF;
		public static const DARK_PURPLE:uint = 0x5500BB;
		public static const LIGHT_PURPLE:uint = 0xBB66FF;
		
		public static const ORANGE:uint = 0xFF7700;
		public static const DARK_ORANGE:uint = 0xBB5500;
		public static const LIGHT_ORANGE:uint = 0xFFBB77;
		
		public static const WHITE:uint = 0xFFFFFF;
		public static const BLACK:uint = 0x000000;
		
		public static const GREY:uint = 0x999999;
		public static const LIGHT_GREY:uint = 0xBBBBBB;
		public static const DARK_GREY:uint = 0x555555;
		
		/**
		 * composes a 24-bit color from the given values
		 * @param	red			the red channel ranging from 0 to 255
		 * @param	green		the green channel ranging from 0 to 255
		 * @param	blue		the blue channel ranging from 0 to 255
		 * @return				the composed color
		 */
		public static function compose(red:uint = 255, green:uint = 255, blue:uint = 255):uint
		{
			return red << 16 | green << 8 | blue;
		}
		/**
		 * decomposes any 24-bit color into its original red, green and blue channels.
		 * The result will be returned in an Array with the following indexing
		 * Array[0] = red channel
		 * Array[1] = green channel;
		 * Array[2] = blue channel
		 * @param	color24
		 * @return		a Array with seperate channels
		 */
		public static function decompose(color24:uint):Array
		{
			var r:uint = color24 >> 16 & 0xFF;
			var g:uint = color24 >> 8 & 0xFF;
			var b:uint = color24 & 0xFF;
			var list:Array = [r, g, b];
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
			var i:int; var max:int = 3; var multiplier:Number = 1 / (steps - 1);
			for (i = 0; i < max; i++) channelDif[i] = channelsB[i] - channelsA[i];
			for (i = 0; i < max; i++) channelDif[i] *= multiplier;
			var prevColor:uint;
			var r:uint, g:uint, b:uint;
			var prevChannels:Array = [];
			for (i = 1; i < steps; i++) {
				prevColor = colors[i - 1];
				prevChannels = decompose(prevColor);
				r = prevChannels[0] + channelDif[0];
				g = prevChannels[1] + channelDif[1];
				b = prevChannels[2] + channelDif[2];
				colors[i] = compose(r, g, b);
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
		/**
		 * returns a random 24-bit color value
		 * @return				a random 24-bit color
		 */
		public static function random():uint
		{
			var r:int = Math.random() * 255;
			var g:int = Math.random() * (255 - r);
			var b:int = Math.random() * (255 - r - g);
			return compose(r, g, b);
		}
	}

}