package
{
	import flash.display.Sprite;
	import it.h_umus.tuio.Tuio2DCurClient;
	import it.h_umus.tuio.events.Tuio2DCurEvent;
	import it.h_umus.tuio.events.TuioEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	[SWF(width="800", height="600")]
	
	public class Tuio2DCurDEMO extends Sprite
	{
		private var items:Dictionary = new Dictionary();
		private const _width:uint=800;
		private const _height:uint=600;
		
		public function Tuio2DCurDEMO()
		{
			var tuioClient2Dcur:Tuio2DCurClient = new Tuio2DCurClient();
			tuioClient2Dcur.addEventListener(Tuio2DCurEvent.ADD_TUIO_2D_CUR,addTuioCur);
			tuioClient2Dcur.addEventListener(Tuio2DCurEvent.REMOVE_TUIO_2D_CUR,removeTuioCur);
			tuioClient2Dcur.addEventListener(Tuio2DCurEvent.UPDATE_TUIO_2D_CUR,updateTuioCur);
			tuioClient2Dcur.addEventListener(Event.CONNECT, traceEvent);
			tuioClient2Dcur.addEventListener(Event.CLOSE, traceEvent);
			tuioClient2Dcur.addEventListener(IOErrorEvent.IO_ERROR, traceEvent);
			tuioClient2Dcur.addEventListener(SecurityErrorEvent.SECURITY_ERROR, traceEvent);
			tuioClient2Dcur.connect();
		}
		
		
		private function addTuioCur(event:Tuio2DCurEvent):void{
			var a:Cursor = new Cursor();
			items[event.data.s]=a;
			addChild(a);
		}
		
		private function removeTuioCur(event:Tuio2DCurEvent):void{
			removeChild(items[event.data.s]);
			items[event.data.s]=null;
			delete(items[event.data.s]);
		}
		
		private function updateTuioCur(event:Tuio2DCurEvent):void{
			var a:Cursor =items[event.data.s];
			a.x = event.data.x * _width;
			a.y = event.data.y * _height;
		}
		
		private function refresh(event:TuioEvent):void{
			
		}
		
		private function traceEvent(event:Event):void{
			trace(event.type);
		}
		
	}
}