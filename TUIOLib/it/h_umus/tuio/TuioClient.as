package it.h_umus.tuio
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import it.h_umus.osc.OSCConnection;
	import it.h_umus.osc.OSCConnectionEvent;
	import it.h_umus.osc.OSCMessage;
	import it.h_umus.osc.OSCArgument;
	import flash.utils.Dictionary;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import it.h_umus.tuio.events.TuioEvent;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DCurEvent;
	import flash.events.DataEvent;
	

	/**
	 * @eventType it.h_umus.tuio.events.Tuio2DCurEvent.ADD_TUIO_2D_CUR
	 **/
	[Event(name="addTuio2DCur", type="it.h_umus.tuio.events.Tuio2DCurEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.events.Tuio2DCurEvent.UPDATE_TUIO_2D_CUR
	 **/
	[Event(name="updateTuio2DCur", type="it.h_umus.tuio.events.Tuio2DCurEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.events.Tuio2DCurEvent.REMOVE_TUIO_2D_CUR
	 **/
	[Event(name="removeTuio2DCur", type="it.h_umus.tuio.events.Tuio2DCurEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.ADD_TUIO_2D_OBJ
	 **/
	[Event(name="addTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ
	 **/
	[Event(name="updateTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ
	 **/
	[Event(name="removeTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.REFRESH
	 **/
	[Event(name="refresh", type="it.h_umus.tuio.events.TuioEvent")]

	/**
	 * 
	 * @author Ignacio Delgado
	 * @see http://code.google.com/p/tuio-as3-lib
	 * @see http://code.google.com/p/flosc
	 * @see http://mtg.upf.es/reactable/?software
	 * 
	 */
	public class TuioClient extends EventDispatcher
	{
		private var _OSCReceiver:OSCConnection;
		private var _port:uint = 3333;
		private var _address:String = "localhost";
		
		private var _currentFrame:int = 0;
		private var _lastFrame:int =0;
		
		private var _objectsList:Dictionary = new Dictionary();
		private var _newObjectList:Dictionary = new Dictionary();
		private var _aliveObjectList:Dictionary = new Dictionary();
		
		private var _cursorsList:Dictionary = new Dictionary();
		private var _newCursorList:Dictionary = new Dictionary();
		private var _aliveCursorList:Dictionary = new Dictionary();
		
		
		/**
		 * 
		 * @param address
		 * @param port
		 * 
		 */
		public function TuioClient(address:String="localhost", port:uint=3000){
			_port = port;
			_address = address;
			_OSCReceiver = new OSCConnection(_address, _port);
			_OSCReceiver.addEventListener(OSCConnectionEvent.OSC_PACKET_IN, onPacketIn);		
			_OSCReceiver.addEventListener(Event.CONNECT,onConnect);
			_OSCReceiver.addEventListener(Event.CLOSE,onClose);
			_OSCReceiver.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_OSCReceiver.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);	
		}
		
		
		public function getPort():uint{
			return _port;
		}
		
		
		public function connect():void{
			_OSCReceiver.connect(_address, _port)
		}
		
		public function disconnect():void{
			_OSCReceiver.close();
		}
		
		private function onPacketIn(event:OSCConnectionEvent):void{
			for each(var message:OSCMessage in event.data.messages)
				processMessage(message);
		}
		
		private function processMessage(message:OSCMessage):void{
			
			var command:String = (String)(message.getArgumentValue(0));
			
			switch(message.name){
				
				case "/tuio/2Dobj":
					if((command == "set") && (_currentFrame >= _lastFrame))
					{	
						var s:int = message.getArgumentValue(1) as int;
						var i:int = message.getArgumentValue(2) as int;
						var x:Number = message.getArgumentValue(3) as Number;
						var y:Number = message.getArgumentValue(4) as Number;
						var a:Number = message.getArgumentValue(5) as Number;
						var X:Number = message.getArgumentValue(6) as Number;
						var Y:Number = message.getArgumentValue(7) as Number;
						var A:Number = message.getArgumentValue(8) as Number;
						var m:Number = message.getArgumentValue(9) as Number;
						var r:Number = message.getArgumentValue(10) as Number;
						
						if(_objectsList[s]==null)
						{
							var tuio2Dobj:Tuio2DObj = new Tuio2DObj(s, i, x, y, a, X, Y, A, m, r);
							_objectsList[s] = tuio2Dobj;
							dispatchEvent(new Tuio2DObjEvent(Tuio2DObjEvent.ADD_TUIO_2D_OBJ, tuio2Dobj));
							dispatchEvent(new Tuio2DObjEvent(Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ, tuio2Dobj));

						}else{
							var tuio2Dobj:Tuio2DObj = _objectsList[s] as Tuio2DObj;
							if((tuio2Dobj.x!=x)||(tuio2Dobj.y!=y)||(tuio2Dobj.a!=a)){
								tuio2Dobj.update(x, y, a, X, Y, A, m, r);
								dispatchEvent(new Tuio2DObjEvent(Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ,tuio2Dobj));
								_objectsList[s] = tuio2Dobj;
							}
						}
					}
					else if((command=="alive")&&(_currentFrame >= _lastFrame))
					{
						for(var index:uint = 1; index < message.arguments.length; index++){
							var s:int = message.getArgumentValue(index) as int;
							_newObjectList[s]=s;
							if(_aliveObjectList[s]!=null)
							{
								_aliveObjectList[s]=null;
								delete(_aliveObjectList[s]);
							}
						}
						
						for each(var s:int in _aliveObjectList){
							dispatchEvent(new Tuio2DObjEvent(Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ, _objectsList[s] as Tuio2DObj));
							_objectsList[s]=null;
							delete(_objectsList[s]);
						}
						
						var buffer:Dictionary = _aliveObjectList;
						_aliveObjectList = _newObjectList;
						_newObjectList = buffer;
						for (var key:Object in _newObjectList) {
							_newObjectList[key]=null;
							delete(_newObjectList[key]);
						}	
					}
					else if(command == "fseq"){
						_lastFrame = _currentFrame;
						_currentFrame = message.getArgumentValue(1) as int;
						
						if(_currentFrame == -1)
							_currentFrame = _lastFrame;
						
						if(_currentFrame >= _lastFrame)
							dispatchEvent(new TuioEvent(TuioEvent.REFRESH));	
					}
					break;
					
				case "/tuio/2Dcur":
					if((command == "set") && (_currentFrame >= _lastFrame))
					{
						var s:int = message.getArgumentValue(1) as int;
						var x:Number = message.getArgumentValue(2) as Number;
						var y:Number = message.getArgumentValue(3) as Number;
						var X:Number = message.getArgumentValue(4) as Number;
						var Y:Number = message.getArgumentValue(5) as Number;
						var m:Number = message.getArgumentValue(6) as Number;
						
						var tuio2Dcur:Tuio2DCur = new Tuio2DCur(s, x, y, X, Y, m);
						
						if(_cursorsList[s] == null)
						{
							var tuio2Dcur:Tuio2DCur = new Tuio2DCur(s, x, y, X, Y, m);
							_cursorsList[s] = tuio2Dcur;
							dispatchEvent(new Tuio2DCurEvent(Tuio2DCurEvent.ADD_TUIO_2D_CUR, tuio2Dcur));
							dispatchEvent(new Tuio2DCurEvent(Tuio2DCurEvent.UPDATE_TUIO_2D_CUR, tuio2Dcur));	
						}
						else
						{
							var tuio2Dcur:Tuio2DCur = _cursorsList[s] as Tuio2DCur;
							tuio2Dcur.update(x, y, X, Y, m);
							dispatchEvent(new Tuio2DCurEvent(Tuio2DCurEvent.UPDATE_TUIO_2D_CUR, tuio2Dcur));
							_cursorsList[s] = tuio2Dcur;
						}
					}
					else if((command=="alive")&&(_currentFrame >= _lastFrame))
					{
						for(var index:uint = 1; index < message.arguments.length; index++){
							var s:int = message.getArgumentValue(index) as int;
							_newCursorList[s]=s;
							if(_aliveCursorList[s]!=null)
							{
								_aliveCursorList[s]=null;
								delete(_aliveCursorList[s]);
							}
						}
						
						for each(var s:int in _aliveCursorList){
							dispatchEvent(new Tuio2DCurEvent(Tuio2DCurEvent.REMOVE_TUIO_2D_CUR, _cursorsList[s] as Tuio2DCur));
							_cursorsList[s] = null;
							delete(_cursorsList[s]);
						}
						
						var buffer:Dictionary = _aliveCursorList;
						_aliveCursorList = _newCursorList;
						_newCursorList = buffer;
						for (var key:Object in _newCursorList) {
							_newCursorList[key]=null;
							delete(_newCursorList[key]);
						}
					}
					else if(command == "fseq"){
						_lastFrame = _currentFrame;
						_currentFrame = message.getArgumentValue(1) as int;
						
						if(_currentFrame == -1)
							_currentFrame = _lastFrame;
						
						if(_currentFrame >= _lastFrame)
							dispatchEvent(new TuioEvent(TuioEvent.REFRESH));
					}
					break;
				
			}
		}
		
		
		// *** event handler to respond to successful connection attempt
		protected function onConnect (event:Event) : void {
			dispatchEvent(event);
		}
	
	
		// *** event handler called when server kills the connection
		protected function onClose (event:Event) : void {
			dispatchEvent(event);
		}
	
		
		protected function onIOError(event:IOErrorEvent) : void {
			//trace("OSCConnection.onConnectError()");		
			dispatchEvent(event);
		}
		
		protected function onSecurityError(event:Event) : void {
			//trace("OSCConnection.onConnectError()");		
			dispatchEvent(event);
		}
		
	}
}