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
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.ADD_TUIO_OBJ
	 **/
	[Event(name="addTuioObj", type="it.h_umus.tuio.TuioEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.UPDATE_TUIO_OBJ
	 **/
	[Event(name="updateTuioObj", type="it.h_umus.tuio.TuioEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.REMOVE_TUIO_OBJ
	 **/
	[Event(name="removeTuioObj", type="it.h_umus.tuio.TuioEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.ADD_TUIO_CUR
	 **/
	[Event(name="addTuioCur", type="it.h_umus.tuio.TuioEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.UPDATE_TUIO_OBJ
	 **/
	[Event(name="updateTuioCur", type="it.h_umus.tuio.TuioEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.REMOVE_TUIO_OBJ
	 **/
	[Event(name="removeTuioCur", type="it.h_umus.tuio.TuioEvent")]
	
	/**
	 * @eventType it.h_umus.tuio.TuioEvent.REFRESH
	 **/
	[Event(name="refresh", type="it.h_umus.tuio.TuioEvent")]

	/**
	 * 
	 * @author Ignacio Delgado
	 * @see http://code.google.com/p/tuio-as3-lib
	 * @see http://code.google.com/p/flosc
	 * @see http://mtg.upf.edu/software?reactivision
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
						var data:Object = new Object();
						data.s_id = (int)(message.getArgumentValue(1));
						data.f_id = (int)(message.getArgumentValue(2));
						data.x = (Number)(message.getArgumentValue(3));
						data.y = (Number)(message.getArgumentValue(4));
						data.a = (Number)(message.getArgumentValue(5));
						data.X = (Number)(message.getArgumentValue(6));
						data.Y = (Number)(message.getArgumentValue(7));
						data.A = (Number)(message.getArgumentValue(8));
						data.m = (Number)(message.getArgumentValue(9));
						data.r = (Number)(message.getArgumentValue(10));
						
						if(_objectsList[data.s_id]==null)
						{
							var tuio:Tuio = new Tuio(data.s_id, data.x, data.y, data.a);
							_objectsList[data.s_id] = tuio;
							
							dispatchEvent(new TuioEvent(TuioEvent.ADD_TUIO_OBJ,data));
							dispatchEvent(new TuioEvent(TuioEvent.UPDATE_TUIO_OBJ,data));

						}else{
							var tuio:Tuio = (Tuio)(_objectsList[data.s_id]);
							if((tuio.xpos!=data.x)||(tuio.ypos!=data.y)||(tuio.angle!=data.a)){
								dispatchEvent(new TuioEvent(TuioEvent.UPDATE_TUIO_OBJ,data));
								tuio.update(data.x,data.y,data.a);
								_objectsList[data.s_id]=tuio;
							}
						}
					}
					else if((command=="alive")&&(_currentFrame >= _lastFrame))
					{
						for(var i:uint = 1; i < message.arguments.length; i++){
							var s_id:int = (int)(message.getArgumentValue(i));
							_newObjectList[s_id]=s_id;
							if(_aliveObjectList[s_id]!=null)
							{
								_aliveObjectList[s_id]=null;
								delete(_aliveObjectList[s_id]);
							}
						}
						
						for each(var s_id:int in _aliveObjectList){
							var data:Object = new Object();
							data.s_id=s_id;
							data.f_id = ((Tuio)(_objectsList[s_id])).f_id;
							_objectsList[s_id]=null;
							delete(_objectsList[s_id]);
							dispatchEvent(new TuioEvent(TuioEvent.REMOVE_TUIO_OBJ, data));
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
						_currentFrame = (int)(message.getArgumentValue(1));
						
						if(_currentFrame == -1)
							_currentFrame = _lastFrame;
						
						if(_currentFrame >= _lastFrame)
							dispatchEvent(new TuioEvent(TuioEvent.REFRESH));	
					}
					break;
					
				case "/tuio/2Dcur":
					if((command == "set") && (_currentFrame >= _lastFrame))
					{
						var data:Object = new Object();
						data.s_id = (int)(message.getArgumentValue(1));
						data.x = (Number)(message.getArgumentValue(2));
						data.y = (Number)(message.getArgumentValue(3));
						data.X = (Number)(message.getArgumentValue(4));
						data.Y = (Number)(message.getArgumentValue(5));
						data.m = (Number)(message.getArgumentValue(6));
						
						dispatchEvent(new TuioEvent(TuioEvent.UPDATE_TUIO_CUR,data));
					
					}
					else if((command=="alive")&&(_currentFrame >= _lastFrame))
					{
						for(var i:uint = 1; i < message.arguments.length; i++){
							var s_id:int = (int)(message.getArgumentValue(i));
							_newCursorList[s_id]=s_id;
							if(_aliveCursorList[s_id]!=null)
							{
								_aliveCursorList[s_id]=null;
								delete(_aliveCursorList[s_id]);
							}
							else
							{
								dispatchEvent(new TuioEvent(TuioEvent.ADD_TUIO_CUR,s_id));
							}
						}
						
						for each(var s_id:int in _aliveCursorList){
							dispatchEvent(new TuioEvent(TuioEvent.REMOVE_TUIO_CUR, s_id));
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