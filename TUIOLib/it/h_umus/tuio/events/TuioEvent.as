package it.h_umus.tuio.events
{
	import flash.events.Event;
	
	[Exclude(name="clone", kind="method")]
	
	/**
	 * 
	 * @author Ignacio Delgado
	 * @see http://code.google.com/p/tuio-as3-lib
	 * @see http://mtg.upf.es/reactable/?software
	 * 
	 */
	public final class TuioEvent extends Event
	{
 		
		/**
		 * @eventType refresh
		 **/
		public static const REFRESH:String			= "refresh";
		
		
		public var data:Object;
		
		public function TuioEvent(inType:String, inData:Object=null){
			super(inType);
			data = inData;
		}
		
		public override function clone():Event {
                return new TuioEvent(type, data);
                
        }
	}
}