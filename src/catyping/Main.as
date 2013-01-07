package catyping
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * ...
	 * @author pardoman
	 */
	[Frame(factoryClass="catyping.Preloader")]
	public class Main extends Sprite 
	{
		private var initialMessage:TextField;
		private var game:Game;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Simple background
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0x97CDDF);
			spr.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			spr.graphics.endFill();
			spr.x = 0
			spr.y = 0
			addChild(spr);

			var txtFormat:TextFormat = new TextFormat("Arial", 48);
			txtFormat.align = TextFormatAlign.CENTER;
			initialMessage = new TextField;
			initialMessage.defaultTextFormat = txtFormat;
			initialMessage.selectable = false;
			initialMessage.width = stage.stageWidth * 0.8;
			initialMessage.height = 80;
			initialMessage.multiline = false;
			initialMessage.wordWrap = true;
			initialMessage.text = "Click somewhere!";
			initialMessage.x = stage.stageWidth  / 2 - initialMessage.width / 2;
			initialMessage.y = stage.stageHeight / 2;
			addChild(initialMessage);
			
			stage.addEventListener(MouseEvent.CLICK, onInitialClick);
			
		}
		
		private function onInitialClick(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.CLICK, onInitialClick);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			initialMessage.visible = false;
			
			//Game
			game = new Game();
			addChild(game);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var dt:Number = 1 / stage.frameRate;
			game.update(dt);
		}
		
		

	}

}