package  trb1914.general
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * A general purpose class
	 * @author Mees Gelein
	 */
	public class GameScreen extends Sprite 
	{
		private var nameString:String;
		/**
		 * Makes a GameScreen instance, like a main Menu.
		 * @param	parent		the parent to add the gamestate to, can be the stage
		 * @param	name		the optional name of the current gamestate
		 */
		public function GameScreen(parent:DisplayObjectContainer, name:String = "") 
		{
			parent.addChild(this);
			if (name == "") nameString = "unNamed";
			else nameString = name;
		}
		/**
		 * removes the GameScreen from the displaylist if it isn't already removed
		 */
		public function removeMe():void
		{
			if (this.parent != null) parent.removeChild(this);
		}
		/**
		 * returns this instance as a String
		 * @return		this instance as a String
		 */
		public function toString():String
		{
			return "GameState:" + nameString;
		}
		
	}

}