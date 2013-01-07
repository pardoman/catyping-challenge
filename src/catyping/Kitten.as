package catyping 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Kitten extends Sprite
	{
		[Embed(source = "embeded/kitten_1.jpg")] private static const KITTEN_1:Class;
		[Embed(source = "embeded/kitten_2.jpg")] private static const KITTEN_2:Class;
		[Embed(source = "embeded/kitten_3.jpg")] private static const KITTEN_3:Class;
		[Embed(source = "embeded/kitten_4.jpg")] private static const KITTEN_4:Class;
		[Embed(source = "embeded/kitten_5.jpg")] private static const KITTEN_5:Class;
		[Embed(source = "embeded/kitten_6.jpg")] private static const KITTEN_6:Class;
		[Embed(source = "embeded/kitten_7.jpg")] private static const KITTEN_7:Class;
		[Embed(source = "embeded/kitten_8.jpg")] private static const KITTEN_8:Class;
		[Embed(source = "embeded/kitten_9.jpg")] private static const KITTEN_9:Class;
		[Embed(source = "embeded/kitten_10.jpg")] private static const KITTEN_10:Class;
		[Embed(source = "embeded/kitten_11.jpg")] private static const KITTEN_11:Class;
		
		private static var kittenIndex:int = 0;
		private static var allKittens:Array;
		private static var gravity:Number = 100;
		
		
		private var velocity:Point;
		private var dead:Boolean = false;
		private var scale:Number = 1.5;
		
		
		public function Kitten(stageW:Number, stageH:Number) 
		{
			var pic:Bitmap = createKittenBitmap();
			addChild(pic);
			
			x = 50 + Math.random() * (stageW-100);
			y = 50 + Math.random() * (stageH-100);
			
			alpha = 0.25;
			scaleX = scaleY = 1.4;
			rotation = 45 + Math.random() * 45;
			var endRotation:Number = Math.random() * 45 - 27.5;
			
			TweenLite.to(this, 1, { scaleX:1.0, scaleY:1.0, rotation:endRotation, 
				alpha:0.5, onComplete:myOnCompleteFunction});
		}
		
		private function myOnCompleteFunction(x:*=null):void
		{
			dead = true;
		}
		
		private function createKittenBitmap():Bitmap
		{
			if (allKittens == null) {
				allKittens = new Array;
				allKittens.push(KITTEN_1);
				allKittens.push(KITTEN_2);
				allKittens.push(KITTEN_3);
				allKittens.push(KITTEN_4);
				allKittens.push(KITTEN_5);
				allKittens.push(KITTEN_6);
				allKittens.push(KITTEN_7);
				allKittens.push(KITTEN_8);
				allKittens.push(KITTEN_9);
				allKittens.push(KITTEN_10);
				allKittens.push(KITTEN_11);
			}
			
			var c:Class = allKittens[kittenIndex];
			kittenIndex++;
			if (kittenIndex == allKittens.length) {
				kittenIndex = 0;
			}
				
			return new c;
		}
		
		public function update(dt:Number):void
		{
		}
		
		public function destroy():void
		{
			//parent.removeChild(this);
		}
		
		public function isDead():Boolean
		{
			return dead;
		}
		
		public function goAway():void
		{
			//move this to front
			var p:DisplayObjectContainer = parent;
			parent.removeChild(this);
			p.addChild(this);
			
			//tween out!
			TweenLite.to(this, 1, {y:"+50", alpha:0.0, onComplete:onGoAwayComplete});
		}
		
		private function onGoAwayComplete(x:*=null):void
		{
			parent.removeChild(this);
		}
		
	}

}