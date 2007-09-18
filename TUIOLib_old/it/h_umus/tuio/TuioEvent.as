package it.h_umus.tuio
{
	import flash.events.Event;
	
	[Exclude(name="clone", kind="method")]
	
	/**
	 * 
	 * @author Ignacio Delgado
	 * @see http://code.google.com/p/tuio-as3-lib
	 * @see http://mtg.upf.edu/software?reactivision
	 * 
	 */
	public final class TuioEvent extends Event
	{
		/**
		 * @eventType addTuioObj
		 **/
		public static const ADD_TUIO_OBJ:String 	= "addTuioObj";
		
		/**
		 * @eventType updateTuioObj
		 **/
		public static const UPDATE_TUIO_OBJ:String 	= "updateTuioObj";
		
		/**
		 * @eventType removeTuioObj
		 **/
		public static const REMOVE_TUIO_OBJ:String 	= "removeTuioObj";
		
		/**
		 * @eventType addTuioCur
		 **/
		public static const ADD_TUIO_CUR:String		= "addTuioCur";
		
		/**
		 * @eventType updateTuioCur
		 **/
		public static const UPDATE_TUIO_CUR:String 	= "updateTuioCur";
		
		/**
		 * @eventType removeTuioCur
		 **/
		public static const REMOVE_TUIO_CUR:String	= "removeTuioCur";
		
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