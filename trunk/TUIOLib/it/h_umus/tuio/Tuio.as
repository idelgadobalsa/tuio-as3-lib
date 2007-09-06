package it.h_umus.tuio
{
	public class Tuio
	{
		public var f_id:int;
	    public var xpos:Number;
	    public var ypos:Number;
	    public var angle:Number;

	    public function Tuio (id:int, x:Number, y:Number, a:Number) {
	    	this.f_id =  id;
	    	this.xpos =  x;
	    	this.ypos =  y;
	    	this.angle = a;
	    }
	    
 	    public function update(x:Number, y:Number, a:Number):void {
	    	this.xpos =  x;
	    	this.ypos =  y;
	    	this.angle = a;
	    }
	}
}