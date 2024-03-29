package it.h_umus.tuio.profiles
{
	import it.h_umus.osc.OSCMessage;
	import it.h_umus.tuio.ITuioClient;;
	
	/**
	 * 
	 * @author Ignacio Delgado
	 * @see http://code.google.com/p/tuio-as3-lib
	 * @see http://mtg.upf.es/reactable/?software
	 * 
	 */
	public interface IProfile
	{
		function get profileName() : String;
		function processCommand(message:OSCMessage) : void;
		function addDispatcher(dispatcher:ITuioClient) : void;
	}
}