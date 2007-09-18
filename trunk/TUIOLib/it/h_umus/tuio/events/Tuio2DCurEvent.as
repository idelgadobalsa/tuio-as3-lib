package it.h_umus.tuio.events
{
	import flash.events.Event;
	import it.h_umus.tuio.Tuio2DCur;

	public class Tuio2DCurEvent extends Event
	{
		/**
		 * @eventType addTuio2DCur
		 **/
		public static const ADD_TUIO_2D_CUR:String		= "addTuio2DCur";
		
		/**
		 * @eventType updateTuio2DCur
		 **/
		public static const UPDATE_TUIO_2D_CUR:String 	= "updateTuio2DCur";
		
		/**
		 * @eventType removeTuio2DCur
		 **/
		public static const REMOVE_TUIO_2D_CUR:String	= "removeTuio2DCur";
		
		public var data:Tuio2DCur;
		
		public function Tuio2DCurEvent(type:String, data:Tuio2DCur)
		{
			//TODO: implement function
			super(type);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new Tuio2DCurEvent(type,data);
		}
		
	}
}