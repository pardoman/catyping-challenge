package catyping 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;

	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
  
	/**
	 * ...
	 * @author pardoman
	 * * Based on:  http://10fastfingers.com/typing-test/english
	 */
	public class Game extends Sprite
	{
		private static var TAG_GOOD_OPEN:String = "<font color='#3EAC46'>";
		private static var TAG_BAD_OPEN:String = "<font color='#FF0000'>";
		private static var TAG_CLOSE:String = "</font>";
		
		private static const GAME_SECONDS:int = 30;
		
		private var wordDict:WordDictionary;
		private var input:TextField;
		private var words:TextField;
		private var wordsHidden:TextField;
		private var strPrevWords:String = "";
		private var htmlTextFromUserInput:String = "";
		
		//statistics texts
		private var txtTime:TextField;
		private var txtWordsOkay:TextField;
		private var txtWordsNotOkay:TextField;
		
		//results texts
		private var txtWPM:TextField;
		private var txtAccuracy:TextField;
		
		//statistics
		private var wordsOkay:int;
		private var wordsNotOkay:int;
		
		private var wordsToType:Array = new Array;
		private var wordsTypedResult:Array = new Array;
		
		private var gameTimer:Timer;
		private var secondsRemaining:int;
		private var timerStarted:Boolean = false;
		private var littleTimeSprite:Sprite = new Sprite;

		//particles
		private var renderer:BitmapRenderer;
		private var emitter:Emitter2D;
		private var layerParticles:Sprite = new Sprite;
		
		//kittens! GIVE ME KARMA!!!!
		private var kittens:Array = new Array;
		private var layerKittens:Sprite = new Sprite;
		private var txtKittyTotal:TextField;
		private var txtKittyGone:TextField;
		private var kittyGoneCount:int = 0;
		
		public function Game() 
		{
			wordDict = new WordDictionary();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			//little time sprite
			littleTimeSprite.graphics.beginFill(0xFF0000);
			littleTimeSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			littleTimeSprite.graphics.endFill();
			littleTimeSprite.alpha = 0;
			
			//layers
			addChild(littleTimeSprite);
			addChild(layerKittens);
			addChild(layerParticles);
		
			//input
			input = new TextField();
			input.defaultTextFormat = new TextFormat("Arial", 48);
			input.border = true;
			input.borderColor = 0xDCDEFA;
			input.type = TextFieldType.INPUT;
			input.width = stage.stageWidth * 0.5;
			input.height = 80;
			input.x = (stage.stageWidth - input.width) / 2;
			input.y = stage.stageHeight / 2;
			input.addEventListener(Event.CHANGE, onTextInput);
			addChild(input);
			
			//words
			words = new TextField();
			setOutputTextProperties(words);
			words.x = (stage.stageWidth - words.width) / 2;
			words.y = 50;
			words.filters = [new DropShadowFilter(2,45)];
			addChild(words);
			
			//hidden words
			wordsHidden = new TextField();
			setOutputTextProperties(wordsHidden);
			wordsHidden.x = 10000;
			wordsHidden.y = 10000;
			wordsHidden.visible = false;
			addChild(wordsHidden);
			
			generateNextLineWords(true);
			formatOutputTextBasedOnProgress();
			
			//game timer
			secondsRemaining = GAME_SECONDS;
			gameTimer = new Timer(1000, secondsRemaining);
			gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			gameTimer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			
			//timer textfield
			txtTime = new TextField();
			setStatisticsTextProperties(txtTime);
			txtTime.x = 80;
			txtTime.y = 150;
			addChild(txtTime);
			updateRemainingTime();
			
			//words okay
			txtWordsOkay = new TextField();
			setStatisticsTextProperties(txtWordsOkay);
			txtWordsOkay.x = 80;
			txtWordsOkay.y = 150+30;
			addChild(txtWordsOkay);
			
			//words not okay
			txtWordsNotOkay = new TextField();
			setStatisticsTextProperties(txtWordsNotOkay);
			txtWordsNotOkay.x = 80;
			txtWordsNotOkay.y = 150+30+30;
			addChild(txtWordsNotOkay);
			
			///kitty results
			txtKittyTotal = new TextField;
			setKittyResultsTextProperties(txtKittyTotal);
			txtKittyTotal.x = stage.stageWidth / 2 - txtKittyTotal.width / 2;
			txtKittyTotal.y = 400;
			addChild(txtKittyTotal);
			txtKittyTotal.visible = false;
			
			txtKittyGone = new TextField;
			setKittyResultsTextProperties(txtKittyGone);
			txtKittyGone.x = stage.stageWidth / 2 - txtKittyTotal.width / 2;
			txtKittyGone.y = txtKittyTotal.y + 40;
			addChild(txtKittyGone);
			txtKittyGone.visible = false;
			
			
			updateStatistics();
			initializeParticles();
			
			//Initial focus
			stage.focus = input;
		}
		
		private function initializeParticles():void
		{
			renderer = new BitmapRenderer( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight) );
			renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			renderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.95,0 ] ) );
			addChild( renderer );
		}
		
		private function shootFireworks():void
		{
			var fire:Firework = new Firework();
			fire.setRandomPosition( stage );
			
			emitter = fire;
			renderer.addEmitter( emitter );
			emitter.start();
		}
		
		private function setKittyResultsTextProperties(textfield:TextField):void
		{
			textfield.defaultTextFormat = new TextFormat("Arial", 24);
			textfield.border = true;
			textfield.borderColor = 0xA6B6F7;
			textfield.selectable = true;
			textfield.width = 240;
			textfield.height = 40;
			textfield.multiline = false;
			textfield.wordWrap = false;
		}
		
		
		private function setStatisticsTextProperties(textfield:TextField):void
		{
			textfield.defaultTextFormat = new TextFormat("Arial", 18);
			textfield.border = true;
			textfield.borderColor = 0xA6B6F7;
			textfield.selectable = true;
			textfield.width = 180;
			textfield.height = 26;
			textfield.multiline = false;
			textfield.wordWrap = false;
		}
		
		private function setOutputTextProperties(textfield:TextField):void
		{
			textfield.defaultTextFormat = new TextFormat("Arial", 24);
			textfield.border = true;
			textfield.borderColor = 0xA6B6F7;
			textfield.selectable = false;
			textfield.width = stage.stageWidth * 0.8;
			textfield.height = 80;
			textfield.multiline = true;
			textfield.wordWrap = true;
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onTextInput(e:Event):void 
		{	
			var text:String = input.text;
			
			//Remove starting white spaces
			if (text.length == 1 && text.charAt(0) == " ") 
			{
				input.text = "";
				formatOutputTextBasedOnProgress();
				return;
			}
			
			if (!timerStarted)
			{
				timerStarted = true;
				gameTimer.start();
				updateRemainingTime();
			}
			 
			//Detect word
			if (text.length > 0 && text.charAt(text.length - 1) == " ")
			{
				var wordCompleted:String = text.substr(0, text.length - 1);
				
				//check progress
				var indexCurrentWordTyped:int = wordsTypedResult.length;
				var wordToCheck:String = wordsToType[indexCurrentWordTyped];
				if (wordToCheck == wordCompleted)
				{
					wordsTypedResult.push(true);
					wordsOkay++;
					createKitten();
				}
				else
				{
					wordsTypedResult.push(false);
					wordsNotOkay++;
					removeKitten();
					removeKitten();
					removeKitten();
				}
				
				//clean
				input.text = "";
				
				//generate new set of words if all line has been processed
				if (wordsTypedResult.length == wordsToType.length) {
					generateNextLineWords(false);
				}
			}
			
			formatOutputTextBasedOnProgress();
			updateStatistics();
		}
		
		private function generateNextLineWords(isFirstTime:Boolean):void
		{
			var validWords:String = "";
			var workingCopy:String = "";
			var loopCount:int = 50;
			wordsHidden.text = "";
			var wordsToAdd:Array = new Array;
			
			do
			{
				//copy current working copy to lineWords
				validWords = workingCopy;
				
				if (workingCopy.length > 0)
					workingCopy += " ";
					
				var nextWord:String = wordDict.GetRandomWord();
				wordsToAdd.push(nextWord);
				
				workingCopy += nextWord;
				wordsHidden.htmlText = workingCopy;
				
				loopCount--;
			}
			while (wordsHidden.numLines == 1 && loopCount > 0);
			
			wordsToType = new Array();
			wordsTypedResult = new Array();
			for (var i:int = 0; i < wordsToAdd.length - 1; ++i)
				wordsToType.push(wordsToAdd[i]);
				
			if (!isFirstTime)
			{
				strPrevWords = htmlTextFromUserInput;
			}
		}
		
		private function formatOutputTextBasedOnProgress():void
		{
			var htmlText:String = "";
			var inputText:String = input.text;
			
			for (var i:int = 0; i < wordsToType.length; ++i)
			{
				var word:String = wordsToType[i];
				
				if (i < wordsTypedResult.length)
				{
					var success:Boolean = Boolean(wordsTypedResult[i]);
					
					if (success)
					{
						htmlText += TAG_GOOD_OPEN;
					} else {
						htmlText += TAG_BAD_OPEN
					}
					htmlText += word;
					htmlText += TAG_CLOSE;
				}
				else if (i == wordsTypedResult.length)
				{	
					if (inputText.length > word.length)
					{
						//word is too long!
						//paint red
						htmlText += TAG_BAD_OPEN;
						htmlText += word;
						htmlText += TAG_CLOSE;
					}
					else if (inputText.length == word.length)
					{
						//same amount of letters, check if equal
						if (inputText == word)
						{
							//paint green
							htmlText += TAG_GOOD_OPEN;
							htmlText += word;
							htmlText += TAG_CLOSE;
						}
						else
						{
							//paint red
							htmlText += TAG_BAD_OPEN;
							htmlText += word;
							htmlText += TAG_CLOSE;
						}
					}
					else
					{
						//word is too short, check substring
						var j:int;
						for (j = 0; j < inputText.length; ++j)
						{
							if (inputText.charAt(j) != word.charAt(j))
							{
								break;
							}
						}
						
						if (j == inputText.length)
						{
							//all good! 
							//paint green the already written input. 
							htmlText += TAG_GOOD_OPEN;
							htmlText += inputText;
							htmlText += TAG_CLOSE;
							//The rest should stay black
							htmlText += word.substr(inputText.length);
						}
						else
						{
							//wow! An error in the input :/
							//paint the equal part in green,
							htmlText += TAG_GOOD_OPEN;
							htmlText += word.substr(0,j);
							htmlText += TAG_CLOSE;
							//the wrong part in red 
							htmlText += TAG_BAD_OPEN;
							htmlText += word.substr(j,inputText.length-j);
							htmlText += TAG_CLOSE;
							//and the rest in black
							htmlText += word.substr(inputText.length);
						}
						
					}
					
				}
				else
				{
					//words yet to type
					htmlText += word;
				}
				
				if (i < wordsToType.length-1)
					htmlText += " ";
			}
			
			//copy generated htmlText
			htmlTextFromUserInput = htmlText;
			
			//Pass it on to the output textfield.
			if (strPrevWords.length > 0)
				words.htmlText = strPrevWords + "<br />" + htmlText;
			else
				words.htmlText = htmlText;
		}
		
		private function onTimer(e:TimerEvent):void
		{
			secondsRemaining--;
			
			if (secondsRemaining == 0)
			{
				littleTimeSprite.alpha = 0.3;
			}
			else if (secondsRemaining <= 5) 
			{
				littleTimeSprite.alpha = 0.7;
				TweenLite.to(littleTimeSprite, 0.45, {alpha:0});
			}
			
			updateRemainingTime();
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			input.mouseEnabled = false;
			input.visible = false;
			stage.focus = null;
			showResults();
			shootFireworks();
		}
		
		private function updateRemainingTime():void
		{
			if (secondsRemaining > 0) 
			{
				txtTime.text = secondsRemaining.toString() + " seconds";

				if (!timerStarted)
				{
					txtTime.text = "(" + txtTime.text + ")";
				}
			}
			else
			{
				txtTime.text = "Time is up!";
			}
		}
		
		private function updateStatistics():void
		{
			txtWordsOkay.text = "OK: " + wordsOkay.toString();
			txtWordsNotOkay.text = "Not OK:" + wordsNotOkay.toString();
		}
		
		private function showResults():void 
		{
			//Words Per Minute
			txtWPM = new TextField();
			setStatisticsTextProperties(txtWPM);
			txtWPM.x = 300;
			txtWPM.y = 150;
			txtWPM.text = (60 * (wordsOkay+wordsNotOkay) / GAME_SECONDS).toString() + " WPM!";
			addChild(txtWPM);
			
			//Accuracy
			txtAccuracy = new TextField;
			setStatisticsTextProperties(txtAccuracy);
			txtAccuracy.x = 300;
			txtAccuracy.y = 150 + 30;
			if ((wordsOkay + wordsNotOkay) == 0) {
				txtAccuracy.text = "0%";
			} else {
				txtAccuracy.text = int(wordsOkay * 100 / (wordsOkay + wordsNotOkay)) + "%";
			}
			addChild(txtAccuracy);
			
			//kitties!!!
			txtKittyTotal.text = "Kittens stamped: " + kittens.length;
			txtKittyTotal.visible = true;
			txtKittyGone.text = "Runaway kitties: " + kittyGoneCount;
			txtKittyGone.visible = true;
		}
		
		public function update(dt:Number):void
		{
			/*
			for (var i:int = kittens.length-1; i >= 0; i--) 
			{
				var kitten:Kitten = kittens[i];
				kitten.update(dt);
				
				if (kitten.isDead()) 
				{
					kitten.destroy();
					kittens.splice(i, 1);
				}
			}*/
		}
		
		private function createKitten():void
		{
			var kitten:Kitten = new Kitten(stage.stageWidth, stage.stageHeight);
			kittens.push(kitten);
			layerKittens.addChild(kitten);
		}
		
		private function removeKitten():void
		{
			if (kittens.length > 0)
			{
				var index:int = int(Math.floor( Math.random() * kittens.length ));
				var k:Kitten = kittens[index] as Kitten;
				kittens.splice(index, 1);
				k.goAway();
				kittyGoneCount++;
			}
		}
		
	}

}