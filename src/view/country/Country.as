package view.country
{
	import flash.display.DisplayObject;
	
	import lui.LUIWidget;
	
	import view.renderers.CountryRenderer;

	public class Country extends LUIWidget
	{
		private var _bg:CountryRenderer = new CountryRenderer();
		
		public function Country()
		{
			addChild(_bg);
		}
	}
}