package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import it.h_umus.tuio.Tuio2DObjClient;
	import it.h_umus.tuio.events.TuioEvent;
	import it.h_umus.tuio.events.Tuio2DObjEvent;

	[SWF(width="800", height="600")]
	
	public class Tuio2DObjDEMO extends Sprite
	{
		private var items:Dictionary = new Dictionary();
		private const _width:uint=800;
		private const _height:uint=600;
		
		public function Tuio2DObjDEMO()
		{
			var tuioClient2Dobj:Tuio2DObjClient = new Tuio2DObjClient();
			tuioClient2Dobj.addEventListener(Tuio2DObjEvent.ADD_TUIO_2D_OBJ,addTuioObj);
			tuioClient2Dobj.addEventListener(Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ,removeTuioObj);
			tuioClient2Dobj.addEventListener(Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ,updateTuioObj);
			tuioClient2Dobj.addEventListener(Event.CONNECT, traceEvent);
			tuioClient2Dobj.addEventListener(Event.CLOSE, traceEvent);
			tuioClient2Dobj.addEventListener(IOErrorEvent.IO_ERROR, traceEvent);
			tuioClient2Dobj.addEventListener(SecurityErrorEvent.SECURITY_ERROR, traceEvent);
			tuioClient2Dobj.connect();
		}
		
		private function addTuioObj(event:Tuio2DObjEvent):void{
			//trace(event.type);	
			var a:Item = new Item(event.data.i);
			items[event.data.s]=a;
			addChild(a);
		}
		
		private function removeTuioObj(event:Tuio2DObjEvent):void{
			//trace(event.type);	
			removeChild(items[event.data.s]);
			items[event.data.s]=null;
			delete(items[event.data.s]);
		}
		
		private function updateTuioObj(event:Tuio2DObjEvent):void{
			//trace(event.type);
			var a:Item =items[event.data.s];
			a.x = event.data.x * _width;
			a.y = event.data.y * _height;
			a.rotation = event.data.a * 180/Math.PI;
		}
		
		private function refresh(event:TuioEvent):void{
			
		}
		
		private function traceEvent(event:Event):void{
			trace(event.type);
		}
		
	}
}