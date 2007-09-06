package it.h_umus.tuio
{
	import flash.events.Event;
	//import it.h_umus.util.GenericDataEvent;

	public final class TuioEvent extends Event
	{
		public static const ADD_TUIO_OBJ:String 	= "addTuioObj";
		public static const UPDATE_TUIO_OBJ:String 	= "updateTuioObj";
		public static const REMOVE_TUIO_OBJ:String 	= "removeTuioObj";
		
		public static const ADD_TUIO_CUR:String		= "addTuioCur";
		public static const UPDATE_TUIO_CUR:String 	= "updateTuioCur";
		public static const REMOVE_TUIO_CUR:String	= "removeTuioCur";
		
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