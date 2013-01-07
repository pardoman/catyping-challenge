package catyping 
{
	import flash.display.Stage;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscZone;
	
	import flash.geom.Point;
  
	/**
	 * ...
	 * @author ...
	 */
	public class Firework extends Emitter2D
	{
		private var stageRef :Stage;
		
		public function Firework() 
		{
			counter = new Blast(150);
      
			addInitializer( new SharedImage( new Dot( 2 ) ) );
			addInitializer( new ColorInit( 0xFF3EAC46 , 0xFF60D753 ) );
			addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 200, 140 ) ) );
			addInitializer( new Lifetime( 5 ) );

			addAction( new Age( Quadratic.easeIn ) );
			addAction( new Move() );
			addAction( new Fade() );
			addAction( new Accelerate( 0, 30 ) );
			addAction( new LinearDrag( 0.7 ) );

			addEventListener(EmitterEvent.EMITTER_EMPTY, restart, false, 0, true);
		}
		
		public function setRandomPosition(stage:Stage):void
		{
			stageRef = stage;
			x = 100 + Math.random() * (stage.stageWidth - 200);
			y = 150 + Math.random() * (stage.stageHeight -200);
		}
		
		public function restart(ev:EmitterEvent):void
		{
			setRandomPosition(stageRef);
			start();
		}
	}

}