package
{
	import flash.display.MovieClip;
	import flash.display.GradientType;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.text.TextFormat;
	
	
	
	public class Item extends MovieClip
	{
		[Embed(source="C:/WINDOWS/Fonts/ARIAL.TTF", fontFamily="Arial")]
		private var _arial_str:String;
		
		public function Item(f_id:int)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.beginGradientFill(flash.display.GradientType.LINEAR,[0xFF0000,0x00FF00],[1,1],[0x00,0xFF]);
			shape.graphics.drawRect(-20,-20,40,40);
			shape.graphics.endFill();
			
			addChild(shape);
			
			var field:TextField = new TextField();
			field.embedFonts = true;
			field.text=String(f_id);
			
			var formatter:TextFormat = new TextFormat();
			formatter.font="Arial";
			field.setTextFormat(formatter);
			addChild(field);
			
		}
		
	}
}