package it.h_umus.tuio.events
{
	import flash.events.Event;
	import it.h_umus.tuio.Tuio2DObj;

	public class Tuio2DObjEvent extends Event
	{
		/**
		 * @eventType addTuio2DObj
		 **/
		public static const ADD_TUIO_2D_OBJ:String 	= "addTuio2DObj";
		
		/**
		 * @eventType updateTuio2DObj
		 **/
		public static const UPDATE_TUIO_2D_OBJ:String 	= "updateTuio2DObj";
		
		/**
		 * @eventType removeTuio2DObj
		 **/
		public static const REMOVE_TUIO_2D_OBJ:String 	= "removeTuio2DObj";
		
		public var data:Tuio2DObj;
		
		public function Tuio2DObjEvent(type:String, data:Tuio2DObj)
		{
			//TODO: implement function
			super(type);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new Tuio2DObjEvent(type,data);
		}
		
	}
}