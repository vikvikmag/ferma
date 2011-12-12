package view
{
	import flash.events.Event;
	
	import lui.LUIWidget;
	
	import myLib.ui.STAGE;
	
	import view.country.CountryWidget;
	import view.panel.PlantsPanel;

	public class MainStage extends LUIWidget
	{
		private var _country:CountryWidget;		
		private var _plantsPanel:PlantsPanel;
		public static var WIDTH:int;
		public static var HEIGHT:int;
		
		public function MainStage()
		{
			_country = new CountryWidget();
			_plantsPanel = new PlantsPanel();
			_plantsPanel.addEventListener(Event.CHANGE, onPlantsPanelChange);
			
			PopupManager.modalBackgroundColor = 0x000000;
			PopupManager.modalBackgroundAlpha = 0.3;			
			
			addChild(_country);
			addChild(_plantsPanel);
			addChild(PopupManager.layer);
		}
		
		private function onPlantsPanelChange(event:Event):void
		{
			resize();
		}
		
		override public function resize():void
		{
			WIDTH = _width;
			HEIGHT = _height;
			_plantsPanel.x = 10;
			_plantsPanel.y = _height - _plantsPanel.height - 10;
			PopupManager.setScreenSize(_width, _height);
		}
	}
}