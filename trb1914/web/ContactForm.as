package  trb1914.web
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author trb1914
	 */
	public class ContactForm extends Sprite 
	{
		private var textFormat:TextFormat;
		private var mailTo:String;
		private var phpURL:String;
		
		private var nameLabel:TextField;
		private var emailLabel:TextField;
		private var messageLabel:TextField;
		private var nameField:TextField;
		private var emailField:TextField;
		private var messageField:TextField;
		
		private var ySpacing:Number;
		private var fontSize:Number = 12;
		private var wrongColor:uint = 0xDD0000;
		private var standardColor:uint = 0x000000;
		
		private var scrollBarWidth:Number = 10;
		private var scrollButton:Sprite = new Sprite();
		private var scrolling:Boolean = false;
		private var lastMaxScroll:int = 1;
		
		private var sendButton:Sprite = new Sprite();
		private var scrollMaxY:Number;
		private var scrollMinY:Number;
		/**
		 * creates a new ContactForm instace. Use the public methods to skin it.
		 * @param	parent			the parent to add it to the displayList
		 * @param	frmt			the textFormt, can be changed later on, null means Times New Roman 12 black.
		 * @param	emailPhpURL		the url of the PHP file that sends the email
		 * @param	mailTo			the email adress to send the email to
		 */
		public function ContactForm(parent:DisplayObjectContainer, frmt:TextFormat = null, emailPhpURL:String = "", mailTo:String = "meesgelein@gmail.com") 
		{
			parent.addChild(this);
			phpURL = emailPhpURL;
			textFormat = frmt;
			this.mailTo = mailTo;
			if (frmt) {
				fontSize = frmt.size as Number;
				standardColor = frmt.color as uint;
			}
			fontSize += 5;
			ySpacing = fontSize + 10;
			setUpForm();
			setWidth(500);
			drawScrollBar();
			drawScrollButton(messageField.height);
			drawSendButton();
			addEventListener(Event.ENTER_FRAME, checkScrolling);
			sendButton.addEventListener(MouseEvent.CLICK, onSendClick);
			scrollMinY = messageField.y + 2;
			scrollMaxY = messageField.y + messageField.height - scrollButton.height - 1;
			setFormat(frmt);
		}
		/**
		 * sets the border color of the textFields.
		 * @param	border				a flag indicating if a border should be used
		 * @param	borderColor			the color of the border
		 */
		public function setBorder(border:Boolean = true, borderColor:uint = 0x555555):void
		{
			messageField.border = emailField.border = nameField.border = border;
			messageField.borderColor = emailField.borderColor = nameField.borderColor = borderColor;
			drawScrollBar();
			drawSendButton();
		}
		/**
		 * sets the textFormat of all the textFields, except the sendbutton.
		 * @param	frmt		the TextFormat to set it to
		 */
		public function setFormat(frmt:TextFormat):void
		{
			messageField.defaultTextFormat = emailField.defaultTextFormat = nameField.defaultTextFormat = frmt;
			messageField.setTextFormat(frmt);
			nameField.setTextFormat(frmt);
			emailField.setTextFormat(frmt);
			nameLabel.defaultTextFormat = emailLabel.defaultTextFormat = messageLabel.defaultTextFormat = frmt;
			nameLabel.setTextFormat(frmt);
			emailLabel.setTextFormat(frmt);
			messageLabel.setTextFormat(frmt);
			messageField.embedFonts = emailField.embedFonts = nameField.embedFonts = true;
			nameLabel.embedFonts = emailLabel.embedFonts = messageLabel.embedFonts = true;
		}
		/**
		 * when the send button is clicked
		 * @param	e		the mouseEvent
		 */
		private function onSendClick(e:MouseEvent):void 
		{
			if (checkFields()) {
				sendMessage();
			}
		}
		/**
		 * sends the message using PHP document
		 */
		private function sendMessage():void 
		{
			var my_vars:URLVariables = new URLVariables();
			my_vars.senderName = nameField.text;
			my_vars.senderEmail = emailField.text;
			my_vars.senderTo = mailTo;
			my_vars.senderMsg = messageField.text;
			
			var my_url:URLRequest = new URLRequest(phpURL);
			my_url.method = URLRequestMethod.POST;
			my_url.data = my_vars;
			
			var my_loader:URLLoader = new URLLoader();
			my_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			my_loader.load(my_url);
			
			my_loader.addEventListener(Event.COMPLETE, onMessageSent);
		}
		
		private function onMessageSent(e:Event):void 
		{
			var loader:URLLoader = URLLoader(e.target);
			var vars:URLVariables=new URLVariables(loader.data);
			if (vars.answer == "ok") {
				nameField.text = ""
				emailField.text = ""
				messageField.text = "Uw email is verstuurd.";
			}else {
				messageField.text = "Het versturen is mislukt, probeer het opnieuw.";
			}
		}
		/**
		 * sets the email adress to which we send the email 
		 * @param	emailAdress
		 */
		public function setMailTo(emailAdress:String = "meesgelein@gmail.com"):void
		{
			mailTo = emailAdress;
		}
		/**
		 * draws the default send button.
		 */
		private function drawSendButton():void 
		{
			if(sendButton.parent == this) removeChild(sendButton);
			sendButton = new Sprite();
			var tf:TextField = makeLabel("Verstuur bericht");
			tf.embedFonts = true;
			tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);
			tf.autoSize = TextFieldAutoSize.LEFT; tf.x = 5; tf.y = 3;
			sendButton.addChild(tf);
			addChild(sendButton);
			sendButton.x = messageField.x;
			sendButton.y = messageField.y + messageField.height + 20;
			var g:Graphics = sendButton.graphics;
			g.clear();
			g.beginFill(0,0);
			g.lineStyle(1, messageField.borderColor);
			g.drawRect(0, 0, tf.width + 10, tf.height + 6);
			g.endFill();
		}
		/**
		 * replaces the default send button with a other sprite as 
		 * the button's base.
		 * @param	buttonSprite		the button sprite.
		 */
		public function setSendButtonSprite(buttonSprite:Sprite):void
		{
			removeChild(sendButton);
			addChild(sendButton = new Sprite());
			sendButton.addEventListener(MouseEvent.CLICK, onSendClick);
			var tf:TextField = makeLabel("Verstuur bericht");
			tf.embedFonts = true; tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);
			tf.autoSize = TextFieldAutoSize.LEFT; tf.x = 5; tf.y = 3;
			sendButton.addChild(buttonSprite);
			sendButton.addChild(tf);
			sendButton.x = messageField.x;
			sendButton.y = messageField.y + messageField.height + 20;
		}
		/**
		 * checks every frame if any scrolling should occur
		 * @param	e		the EnterFrame event.
		 */
		private function checkScrolling(e:Event):void 
		{
			if (messageField.maxScrollV > 1) {
				if (lastMaxScroll != messageField.maxScrollV) {
					lastMaxScroll = messageField.maxScrollV;
					drawScrollButton(messageField.height - (messageField.maxScrollV * 10));
				}
				if (!scrollButton.visible) {
					scrollButton.visible = true;
					scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, onScrollClick);
				}
			}else {
				if (scrollButton.visible) {
					scrollButton.visible = false;
					scrollButton.removeEventListener(MouseEvent.MOUSE_DOWN, onScrollClick);
				}
			}
			if (scrolling) {
				var minY:Number = messageField.y + 2;
				var maxY:Number = messageField.y + messageField.height - scrollButton.height - 1;
				scrollButton.y = (mouseY - (scrollButton.height >> 1));
				scrollButton.y = (scrollButton.y < minY) ? minY : scrollButton.y;
				scrollButton.y = (scrollButton.y > maxY) ? maxY : scrollButton.y;
				var relPos:Number = (scrollButton.y - minY) / (maxY - minY);
				messageField.scrollV = int(messageField.maxScrollV * relPos);
			}
		}
		/**
		 * when the scroll button is clicked
		 * @param	e		the MouseEvent
		 */
		private function onScrollClick(e:MouseEvent):void 
		{
			scrolling = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		/**
		 * when the Mouse is released anywhere on the stage.
		 * This is used only when you have clicked the scrollButton previously.
		 * @param	e		the MouseEvent
		 */
		private function onMouseUp(e:MouseEvent):void 
		{
			scrolling = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		/**
		 * draws the scrollbar lines, next to every field.
		 */
		private function drawScrollBar():void 
		{
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(1, messageField.borderColor);
			var startX:Number = messageField.x + messageField.width;
			g.drawRect(startX, messageField.y, scrollBarWidth, messageField.height);
			g.drawRect(startX, emailField.y, scrollBarWidth, emailField.height);
			g.drawRect(startX, nameField.y, scrollBarWidth, nameField.height);
			addChild(scrollButton); scrollButton.x = startX + 2;
			scrollButton.y = messageField.y + 2;
		}
		/**
		 * draws the default scrollbutton
		 * @param	cHeight		the height in pixels, can't get below 20
		 */
		private function drawScrollButton(cHeight:Number):void 
		{
			var g:Graphics = scrollButton.graphics;
			g.clear();
			if (cHeight < 20) cHeight = 20;
			cHeight -= 3;
			g.beginFill(messageField.borderColor, .5);
			g.drawRect(0, 0, scrollBarWidth - 3, cHeight);
			g.endFill();
			scrollButton.visible = false;
		}
		/**
		 * sets up all the labels and input fields.
		 */
		private function setUpForm():void 
		{
			nameLabel = makeLabel("Uw Naam: "); nameLabel.y = ySpacing;
			emailLabel = makeLabel("Uw Email: "); emailLabel.y = ySpacing << 1;
			messageLabel = makeLabel("Uw Bericht: "); messageLabel.y = ySpacing * 3;
			messageLabel.autoSize = emailLabel.autoSize = nameLabel.autoSize = TextFieldAutoSize.LEFT;
			var largestWidth:Number = (messageLabel.width > emailLabel.width) ? messageLabel.width:emailLabel.width;
			largestWidth = (largestWidth > nameLabel.width) ? largestWidth:nameLabel.width;
			nameField = makeField(0x555555); nameField.y = nameLabel.y;
			emailField = makeField(0x555555); emailField.y = emailLabel.y;
			messageField = makeField(0x555555); messageField.y = messageLabel.y;
			messageField.multiline = true; messageField.wordWrap = true;
			messageField.height = 300; messageField.mouseWheelEnabled = false;
			nameField.height = emailField.height = fontSize + 4;
			nameField.x = emailField.x = messageField.x = largestWidth;
		}
		/**
		 * sets the width of the input fields. defaults to 300.
		 * @param	value		the width in pixels of all the input fields
		 */
		public function setWidth(value:Number):void
		{
			messageField.width = nameField.width = emailField.width = value;
			scrollMinY = messageField.y + 2;
			scrollMaxY = messageField.y + messageField.height - scrollButton.height - 1;
			drawScrollBar();
			drawSendButton();
		}
		/**
		 * sets the dimension of the message box. When changing the width, all
		 * the other input fields also change width.
		 * @param	width			the width in pixels of the message field
		 * @param	height			the height in pixels of the message field
		 */
		public function setMessageBoxDimensions(width:Number, height:Number = 300):void
		{
			messageField.height = height;
			scrollMinY = messageField.y + 2;
			scrollMaxY = messageField.y + messageField.height - scrollButton.height - 1;
			setWidth(width);
		}
		/**
		 * draws a background color inside the input fields.
		 * @param	value		a flag indicating if the background color is visible
		 * @param	color		the backgroundColor a 24-bit color
		 */
		public function drawBg(value:Boolean = true, color:uint = 0xFFFFFF):void
		{
			nameField.background = messageField.background = emailField.background = value;
			nameField.backgroundColor = messageField.backgroundColor = emailField.backgroundColor = color;
		}
		/**
		 * makes a standard label with the given text, using the standard text format
		 * @param	text			the string to appear in the textfield
		 * @return					the finished textField
		 */
		private function makeLabel(text:String):TextField
		{
			var tf:TextField = makeTextField(text);
			tf.selectable = false;
			return tf;
		}
		/**
		 * creates a standard textfield, with the standard text format.
		 * @param	text			the string to appear in the textfield
		 * @return					the finished textField
		 */
		private function makeTextField(text:String):TextField
		{
			var tf:TextField = new TextField();
			addChild(tf);
			if (textFormat) tf.defaultTextFormat = textFormat;
			tf.text = text;
			if (textFormat) tf.setTextFormat(textFormat);
			return tf;
		}
		/**
		 * creates a standard input field. Using the standard text format.
		 * @param	borderColor		the color to use for the border
		 * @param	text			the string to appear in the textfield
		 * @return					the finished textField
		 */
		private function makeField(borderColor:Number = 0x000000, text:String = ""):TextField
		{
			var tf:TextField = makeTextField(text);
			tf.type = TextFieldType.INPUT;
			tf.border = true; 
			tf.borderColor = borderColor;
			return tf;
		}
		/**
		 * checks if all fields are properly filled out.
		 * @return			true if filled out correctly, false if it contains mistakes
		 */
		private function checkFields():Boolean
		{
			var fieldsOk:Boolean = true;
			if (nameField.text == "") {
				nameField.textColor = wrongColor;
				nameField.text = "U bent uw naam vergeten";
				nameField.addEventListener(MouseEvent.CLICK, onReFill);
				nameField.selectable = false;
				fieldsOk = false;
			}
			if (emailField.text.indexOf("@") == -1) {
				emailField.textColor = wrongColor;
				emailField.text = "Geen goed email adres";
				emailField.addEventListener(MouseEvent.CLICK, onReFill);
				emailField.selectable = false;
				fieldsOk = false;
			}
			if (messageField.text == "") {
				messageField.textColor = wrongColor;
				messageField.text = "Vul hier uw boodschap in.";
				messageField.addEventListener(MouseEvent.CLICK, onReFill);
				messageField.selectable = false;
				fieldsOk = false;
			}			
			return fieldsOk;
		}
		/**
		 * turns a wrongly filled out field back to normal color when clicked
		 * @param	e		the MouseEvent
		 */
		private function onReFill(e:MouseEvent):void 
		{
			var tf:TextField = e.target as TextField;
			tf.removeEventListener(MouseEvent.CLICK, onReFill);
			tf.text = "";
			tf.textColor = standardColor;
			tf.selectable = true;
		}
		
	}

}