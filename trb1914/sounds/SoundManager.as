package trb1914.sounds 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author trb1914
	 */
	public class SoundManager 
	{
		private static var soundsPlaying:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		/**
		 * tries to make a sound from the class used as a param,
		 * and plays it if it succeeds.
		 * @param	soundClass		the class that contains the sound
		 * @return
		 */
		public static function playSound(soundClass:Class):SoundChannel
		{
			var s:Sound = new soundClass() as Sound;
			var sc:SoundChannel = new SoundChannel();
			sc = s.play();
			soundsPlaying[soundsPlaying.length] = sc;
			return sc;
		}
		/**
		 * stops the specified sound from playing
		 * @param	soundChannel		the sound to stop playing
		 */
		public static function stopSound(soundChannel:SoundChannel):void
		{
			var i:int = soundsPlaying.indexOf(soundChannel);
			if (i > -1) {
				soundsPlaying.splice(i, 1);
			}
			soundChannel.stop();
		}
		
		/**
		 * sets the panning of a specified sound
		 * @param	soundChannel		the specified sound
		 * @param	pan					the panning of the sound, with
		 * 								-1 being left, and 1 being right
		 */
		public static function setSoundPan(soundChannel:SoundChannel, pan:Number = 0):void
		{
			var st:SoundTransform;
			if (soundChannel.soundTransform) {
				st = SoundTransform;
				st.pan = pan;
			}
			else st = new SoundTransform(1, pan);
		}
		/**
		 * don't instantiate this class.
		 */
		public function SoundManager() 
		{
			throw new Error("Instantiating the sound manager class is useless XD");
		}
		
	}

}