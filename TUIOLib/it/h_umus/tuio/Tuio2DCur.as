package it.h_umus.tuio
{
	public class Tuio2DCur
	{
		public var s:int;
		public var x:Number;
	    public var y:Number;
	    public var X:Number;
	    public var Y:Number;
	    public var m:Number;
	    
	    public function Tuio2DCur(s:int, x:Number, y:Number, X:Number, Y:Number, m:Number)
	    {
	    	this.s = s;
	    	this.x = x;
	    	this.y = y;
	    	this.X = X;
	    	this.Y = Y;
	    	this.m = m;
	    }
	    
	    public function update(x:Number, y:Number, X:Number, Y:Number, m:Number) : void
	    {
	    	this.x = x;
	    	this.y = y;
	    	this.X = X;
	    	this.Y = Y;
	    	this.m = m;
	    }
	}
}