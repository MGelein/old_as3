package trb1914.sounds {
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	* @author trb1914
	* ...
	*/
	public class DynamicSound extends Sound {
		
		private var _sc:SoundChannel;
		private var _st:SoundTransform;
		private var _s:Sound;
		
		private var _volume:Number = 1;
		private var _panning:Number = 0;
		
		private var _paused:Boolean = false;
		private var _pausedPos:Number;
		/**
		* makes an instance of the DynamicSound class.
		* @param soundClass		the class that contains the sound
		*/
		public function DynamicSound(soundClass:Class) {
			_s = new soundClass() as Sound;
			_sc = new SoundChannel();
			_st = new SoundTransform();
			_sc.soundTransform = _st;
		}
		/**
		* plays the sound, with a given startTime, the number of loops 
		* and the soundtransform.
		* @param startTime		how many milliseconds from the beginning
		*						of the file it starts playing.
		* @param loops			the number of times the file loops. 0 means
		* 						it will only play once.
		* @param sndTransform	the soundTransform has some properties like
		* 						volume and panning.
		*/
		override public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel
		{
			_sc = _s.play(startTime,loops,sndTransform);
			return _sc;
		}
		/**
		* immediately stops the sound from playing.
		*/
		public function stop():void
		{
			_sc.stop();
		}
		/**
		* pauses the sound if the sound is not already paused.
		* Use the resume() method to resume playing the sound
		* from the point you paused.
		*/
		public function pause():void
		{
			if(!_paused){
				_paused = true;
				_pausedPos = _sc.position;
				_sc.stop();
			}
		}
		/**
		* resumes the sound from the point you paused.
		* If you haven't paused, nothing will happen.
		*/
		public function resume():void
		{
			if(_paused){
				_paused = false;
				play(_pausedPos);
			}
		}
		/**
		* the volume of the sound. A number between 0 and 1, 
		* with 0 being silent, and 1 being full volume.
		*/
		public function get volume():Number 
		{ 
			return _volume;
		}
		/**
		* the volume of the sound. A number between 0 and 1, 
		* with 0 being silent, and 1 being full volume.
		*/
		public function set volume(value:Number):void 
		{ 
			_volume = value;
			_st.volume = _volume;
			_sc.soundTransform = _st;
		}
		/**
		* the panning of the sound. A number between -1 and 1,
		* with -1 being completely left, and 1 being completely
		* right panned.
		*/
		public function get panning():Number 
		{ 
			return _panning;
		}
		/**
		* the panning of the sound. A number between -1 and 1,
		* with -1 being completely left, and 1 being completely
		* right panned.
		*/
		public function set panning(value:Number):void
		{ 
			_panning = value;
			trace(_panning);
			_st.pan = panning;
			_sc.soundTransform = _st;
		}
		/**
		* the soundTransform of a sound determines some properties
		* of the sound like volume and panning.
		*/
		public function set soundTransform(value:SoundTransform):void
		{
			_st = value;
			_sc.soundTransform = _st;
		}
		/**
		* the soundTransform of a sound determines some properties
		* of the sound like volume and panning.
		*/
		public function get soundTransform():SoundTransform
		{
			return _st;
		}
		/**
		* the soundChannel is a class that connects a soundTransform
		* with a playing sound, and it provides you with the stop()
		* method.
		*/
		public function set soundChannel(value:SoundChannel):void
		{
			_sc = value;
		}
		/**
		* the soundChannel is a class that connects a soundTransform
		* with a playing sound, and it provides you with the stop()
		* method.
		*/
		public function get soundChannel():SoundChannel
		{
			return _sc;
		}
		/**
		* a Boolean flag. Contains true if this sound is paused.
		*/
		public function get paused():Boolean
		{
			return _paused;
		}
		/**
		* a Boolean flag. Contains true if this sound is paused.
		*/
		public function set paused(value:Boolean):void
		{
			if(value){
				pause();
			}else{
				resume();
			}
		}
	}	
}
