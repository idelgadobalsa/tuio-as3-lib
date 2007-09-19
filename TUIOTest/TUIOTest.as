package {
	import flash.display.Sprite;
	import it.h_umus.osc.OSCConnection;
	import it.h_umus.osc.OSCConnectionEvent;
	import it.h_umus.osc.OSCMessage;
	import it.h_umus.tuio.TuioClient;
	import it.h_umus.tuio.events.TuioEvent;
	import flash.utils.Dictionary;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	import it.h_umus.tuio.events.Tuio2DCurEvent;

	import it.h_umus.tuio.profiles.Tuio2DCurProfile;
	import it.h_umus.tuio.profiles.Tuio2DObjProfile;


	[SWF(width="800", height="600")]
	
	public class TUIOTest extends Sprite
	{
		
		private var items:Dictionary = new Dictionary();
		private const _width:uint=800;
		private const _height:uint=600;
		
		
		public function TUIOTest()
		{			
			var tuioClient:TuioClient = new TuioClient("localhost", 3000);
			
			//listen for tuio2Dcur messages profile
			tuioClient.addProfile(new Tuio2DCurProfile());
			//listen for tuio2Dobj messages profile
			tuioClient.addProfile(new Tuio2DObjProfile());
			
			tuioClient.addEventListener(Tuio2DCurEvent.ADD_TUIO_2D_CUR,addTuioCur);
			tuioClient.addEventListener(Tuio2DCurEvent.REMOVE_TUIO_2D_CUR,removeTuioCur);
			tuioClient.addEventListener(Tuio2DCurEvent.UPDATE_TUIO_2D_CUR,updateTuioCur);
			
			tuioClient.addEventListener(TuioEvent.REFRESH,refresh);
			
			tuioClient.addEventListener(Tuio2DObjEvent.ADD_TUIO_2D_OBJ,addTuioObj);
			tuioClient.addEventListener(Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ,removeTuioObj);
			tuioClient.addEventListener(Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ,updateTuioObj);
			
			tuioClient.addEventListener(Event.CONNECT, traceEvent);
			tuioClient.addEventListener(Event.CLOSE, traceEvent);
			tuioClient.addEventListener(IOErrorEvent.IO_ERROR, traceEvent);
			tuioClient.addEventListener(SecurityErrorEvent.SECURITY_ERROR, traceEvent);
			
			tuioClient.connect();
			
		}
		
		private function traceEvent(event:Event):void{
			trace(event.type);
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
		
	}
}
