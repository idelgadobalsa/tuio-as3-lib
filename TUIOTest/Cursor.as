package
{
	import flash.display.Sprite;

	public class Cursor extends Sprite
	{
		public function Cursor()
		{
			super();
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(-5,-5,5);
			graphics.endFill();
		}
	}
}