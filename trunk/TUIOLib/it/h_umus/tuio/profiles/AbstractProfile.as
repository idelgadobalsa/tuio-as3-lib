package it.h_umus.tuio.profiles
{
	import flash.utils.Dictionary;
	import it.h_umus.osc.OSCMessage;
	import it.h_umus.tuio.events.TuioEvent;
	import flash.events.EventDispatcher;
	import it.h_umus.tuio.AbstractTuio;
	
	public class AbstractProfile implements IProfile
	{
		
		protected var _dispatcher:EventDispatcher;
		
		private var _currentFrame:int = 0;
		private var _lastFrame:int =0;
		
		protected var _objectsList:Dictionary = new Dictionary();
		protected var _newObjectList:Dictionary = new Dictionary();
		protected var _aliveObjectList:Dictionary = new Dictionary();
		
		public function get profileName():String
		{
			return "/tuio/";
		}
		
		public final function addDispatcher(dispatcher:EventDispatcher):void
		{
			_dispatcher = dispatcher;
		}
		
		public final function processCommand(message:OSCMessage) : void
		{
			var command:String = (String)(message.getArgumentValue(0));
			
			if((command == "set") && (_currentFrame >= _lastFrame))
			{
				processSet(message);
			}
			else if((command=="alive")&&(_currentFrame >= _lastFrame))
			{
				processAlive(message);
			}
			else if(command == "fseq")
			{
				processFseq(message);
			}
		}
		
		protected function dispatchRemove(tuio:AbstractTuio) : void
		{
			throw new Error("Abstract Method");
		}
		
		protected function processSet(message:OSCMessage) : void
		{
			throw new Error("Abstract Method");
		}
		
		protected function processAlive(message:OSCMessage):void
		{
			for(var index:uint = 1; index < message.arguments.length; index++)
				{
					var s_id:int = message.getArgumentValue(index) as int;
					_newObjectList[s_id]=s_id;
					if(_aliveObjectList[s_id]!=null)
					{
						_aliveObjectList[s_id]=null;
						delete(_aliveObjectList[s_id]);
					}
				}
						
				for each(var s:int in _aliveObjectList){
					dispatchRemove(_objectsList[s] as AbstractTuio);
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
		
		protected function processFseq(message:OSCMessage):void
		{
			_lastFrame = _currentFrame;
				_currentFrame = message.getArgumentValue(1) as int;
						
				if(_currentFrame == -1)
					_currentFrame = _lastFrame;
						
				if(_currentFrame >= _lastFrame)
					_dispatcher.dispatchEvent(new TuioEvent(TuioEvent.REFRESH));
		}
	}
}