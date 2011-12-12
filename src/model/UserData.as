package model
{
	import flash.geom.Point;
	
	import model.items.Plant;

	public class UserData
	{		
		private var _plants:Vector.<Plant> = new Vector.<Plant>();
				
		public function UserData()
		{
		}
		
		public function addPlant(plant:Plant):void
		{
			_plants.push(plant);
		}
		
		public function removePlant(plant:Plant):void
		{
			var index:int = _plants.indexOf(plant);
			if (index != -1)
			{
				_plants.splice(index, 1);
			}
		}		
		
		public function growUpAllPlants():void
		{
			for each (var plant:Plant in _plants)
			{
				if (plant.level < 5)
				{
					plant.level++;
				}
			}
		}		
		
		public function get plants():Vector.<Plant>
		{
			return _plants;
		}
		
		public function getPlantUnderPoint(point:Point):Plant
		{
			for each(var plant:Plant in _plants)
			{
				if (plant.tileX == point.x && plant.tileY == point.y)
				{
					return plant;
				}
			}
			return null;
		}
	}
}