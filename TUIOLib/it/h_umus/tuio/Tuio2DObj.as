package it.h_umus.tuio
{
	public class Tuio2DObj
	{
		public var s:int;
		public var i:int;
		public var x:Number;
	    public var y:Number;
	    public var a:Number;
	    public var X:Number;
	    public var Y:Number;
	    public var A:Number;
	    public var m:Number;
		public var r:Number;
		
		public function Tuio2DObj(s:int, i:int, x:Number, y:Number, a:Number, X:Number, Y:Number, A:Number, m:Number, r:Number)
		{
			this.s = s;
			this.i = i;
	    	this.x = x;
	    	this.y = y;
	    	this.a = a;
	    	this.X = X;
	    	this.Y = Y;
	    	this.A = A;
	    	this.m = m;
			this.r = r;
		}
		
		public function update(x:Number, y:Number, a:Number, X:Number, Y:Number, A:Number, m:Number, r:Number) : void
		{
			this.x = x;
	    	this.y = y;
	    	this.a = a;
	    	this.X = X;
	    	this.Y = Y;
	    	this.A = A;
	    	this.m = m;
			this.r = r;
		}
	}
}