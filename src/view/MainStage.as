package view
{
	import flash.events.Event;
	
	import lui.LUIWidget;
	
	import view.country.CountryWidget;
	import view.panel.PlantsPanel;

	public class MainStage extends LUIWidget
	{
		private var _country:CountryWidget;		
		private var _plantsPanel:PlantsPanel;
		
		public function MainStage()
		{
			_country = new CountryWidget();
			_plantsPanel = new PlantsPanel();
			_plantsPanel.addEventListener(Event.CHANGE, onPlantsPanelChange);
			
			addChild(_country);
			addChild(_plantsPanel);
		}
		
		private function onPlantsPanelChange(event:Event):void
		{
			resize();
		}
		
		override public function resize():void
		{
			_plantsPanel.x = 10;
			_plantsPanel.y = _height - _plantsPanel.height - 10;
		}
	}
}