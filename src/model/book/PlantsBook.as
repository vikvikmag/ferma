package model.book
{
	import flash.utils.Dictionary;
	
	import model.items.Plant;

	public class PlantsBook
	{
		private static var _instance:PlantsBook;
		public static function get instance():PlantsBook
		{
			return _instance ||= new PlantsBook();
		}
		
		private const _plants:Dictionary = new Dictionary();
		
		public function PlantsBook()
		{
		}
		
		public function init(xml:XML):void
		{
			for each(var node:XML in xml.plants.plant)
			{
				var plant:Plant = new Plant();
				plant.type = node.@type;
				plant.level = node.@level;
				plant.litName = node.@lit_name;
				_plants[plant.type] = plant;
			}
		}
		
		public function getPlantByType(type:String):Plant
		{
			return _plants[type] as Plant;
		}
		
		public function get plants():Dictionary
		{
			return _plants;
		}
	}
}