package {
	import flash.display.Sprite;
	import it.h_umus.osc.OSCConnection;
	import it.h_umus.osc.OSCConnectionEvent;
	import it.h_umus.osc.OSCMessage;
	import it.h_umus.tuio.TuioClient;
	import it.h_umus.tuio.events.TuioEvent;
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.Tuio2DCur;
	import flash.utils.Dictionary;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	import it.h_umus.tuio.events.Tuio2DCurEvent;


	[SWF(width="800", height="600")]
	
	public class TUIOTest extends Sprite
	{
		
		private var items:Dictionary = new Dictionary();
		private const _width:uint=800;
		private const _height:uint=600;
		
		
		public function TUIOTest()
		{			
			var tuioClient:TuioClient = new TuioClient("10.10.4.243");
			//tuioClient.addEventListener(Tuio2DCurEvent.ADD_TUIO_2D_CUR,addTuio);
			//tuioClient.addEventListener(Tuio2DCurEvent.REMOVE_TUIO_2D_CUR,removeTuio);
			//tuioClient.addEventListener(Tuio2DCurEvent.UPDATE_TUIO_2D_CUR,updateTuio);
			tuioClient.addEventListener(TuioEvent.REFRESH,refresh);
			tuioClient.addEventListener(Tuio2DObjEvent.ADD_TUIO_2D_OBJ,addTuio);
			tuioClient.addEventListener(Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ,removeTuio);
			tuioClient.addEventListener(Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ,updateTuio);
			
			tuioClient.addEventListener(Event.CONNECT, traceEvent);
			tuioClient.addEventListener(Event.CLOSE, traceEvent);
			tuioClient.addEventListener(IOErrorEvent.IO_ERROR, traceEvent);
			tuioClient.addEventListener(SecurityErrorEvent.SECURITY_ERROR, traceEvent);
			
			tuioClient.connect();
			
		}
		
		private function traceEvent(event:Event):void{
			trace(event.type);
		}
		
		
		private function addTuio(event:Tuio2DObjEvent):void{
			//trace(event.type);	
			var a:Item = new Item(event.data.i);
			items[event.data.s]=a;
			addChild(a);
		}
		
		private function removeTuio(event:Tuio2DObjEvent):void{
			//trace(event.type);	
			removeChild(items[event.data.s]);
			items[event.data.s]=null;
			delete(items[event.data.s]);
		}
		
		private function updateTuio(event:Tuio2DObjEvent):void{
			//trace(event.type);
			var a:Item =items[event.data.s];
			a.x = event.data.x * _width;
			a.y = event.data.y * _height;
			a.rotation = event.data.a * 180/Math.PI;
		}
		
		private function refresh(event:TuioEvent):void{
			
		}
		
	}
}
