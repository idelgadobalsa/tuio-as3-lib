package {
	import flash.display.Sprite;
	import it.h_umus.osc.OSCConnection;
	import it.h_umus.osc.OSCConnectionEvent;
	import it.h_umus.tuio.TuioClient;
	import it.h_umus.tuio.TuioEvent;
	import flash.utils.Dictionary;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;


	[SWF(width="800", height="600")]
	
	public class TUIOTest extends Sprite
	{
		
		private var items:Dictionary = new Dictionary();
		private const _width:uint=800;
		private const _height:uint=600;
		
		
		public function TUIOTest()
		{
			

			
			/*var connector:OSCConnection = new OSCConnection("localhost",3000);
			connector.addEventListener(OSCConnectionEvent.ON_PACKET_IN, entryData);
			connector.connect();*/
			
			var tuioClient:TuioClient = new TuioClient();
			tuioClient.addEventListener(TuioEvent.ADD_TUIO_OBJ,addTuio);
			//tuioClient.addEventListener(TuioEvent.ADD_TUIO_CUR,entryData);
			tuioClient.addEventListener(TuioEvent.REFRESH,refresh);
			//tuioClient.addEventListener(TuioEvent.REMOVE_TUIO_CUR,entryData);
			tuioClient.addEventListener(TuioEvent.REMOVE_TUIO_OBJ,removeTuio);
			//tuioClient.addEventListener(TuioEvent.UPDATE_TUIO_CUR,entryData);
			tuioClient.addEventListener(TuioEvent.UPDATE_TUIO_OBJ,updateTuio);
			
			tuioClient.addEventListener(Event.CONNECT, traceEvent);
			tuioClient.addEventListener(Event.CLOSE, traceEvent);
			tuioClient.addEventListener(IOErrorEvent.IO_ERROR, traceEvent);
			tuioClient.addEventListener(SecurityErrorEvent.SECURITY_ERROR, traceEvent);
			
			tuioClient.connect();
			
		}
		
		private function traceEvent(event:Event):void{
			trace(event.type);
		}
		
		
		private function addTuio(event:TuioEvent):void{
			//trace(event.type);	
			var a:Item = new Item(event.data.f_id);
			items[event.data.s_id]=a;
			addChild(a);
		}
		
		private function removeTuio(event:TuioEvent):void{
			//trace(event.type);	
			removeChild(items[event.data.s_id]);
			items[event.data.s_id]=null;
			delete(items[event.data.s_id]);
		}
		
		private function updateTuio(event:TuioEvent):void{
			//trace(event.type);
			var a:Item =items[event.data.s_id];
			a.x = event.data.x * _width;
			a.y = event.data.y * _height;
			a.rotation = event.data.a * 180/Math.PI;
		}
		
		private function refresh(event:TuioEvent):void{
			
		}
		
	}
}
