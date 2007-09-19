package it.h_umus.tuio.profiles
{
	import it.h_umus.osc.OSCMessage;
	import flash.events.EventDispatcher;;
	
	public interface IProfile
	{
		function get profileName() : String;
		function processCommand(message:OSCMessage) : void;
		function addDispatcher(dispatcher:EventDispatcher) : void;
	}
}