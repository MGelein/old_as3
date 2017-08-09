package trb1914.particleWorld 
{
	import flash.display.Bitmap;
	import flash.filters.BlurFilter;
	/**
	 * a class for applying effects to the PixelWorld
	 * @author Mees Gelein
	 */
	public class ParticleEffects 
	{
		private var _bmp:Bitmap;
		/**
		 * makes a new instance of the particleEffects class, only used internally by PixelWorld
		 * @param	target
		 */
		public function ParticleEffects(target:Bitmap) 
		{
			_bmp = target;
		}
		/**
		 * sets a BlurFilter
		 * @param	hBlur					the amount of horizontal blur
		 * @param	vBlur					the amount of vertical blur
		 * @param	quality					the quality of the blur
		 */
		public function setBlur(hBlur:Number, vBlur:Number, quality:int = 1):void 
		{
			var _fltrs:Array = _bmp.filters;
			_fltrs[_fltrs.length] = new BlurFilter(hBlur, vBlur, quality);
			_bmp.filters = _fltrs;
		}
		
	}

}