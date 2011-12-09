package view.country
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import lui.LUIWidget;
	
	import view.renderers.CountryRenderer;

	public class CountryWidget extends LUIWidget
	{
		private var _bg:CountryRenderer;
		
		public function CountryWidget()
		{
			_bg = new CountryRenderer();
			_bg.addEventListener(Event.COMPLETE, onBgLoad);
			addChild(_bg);
		}
		
		private function onBgLoad(event:Event):void
		{
			setSize(_bg.width, _bg.height);
		}
	}
}