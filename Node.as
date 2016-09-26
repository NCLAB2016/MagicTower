package
{
	/**
	 * Represents a specific node evaluated as part of a pathfinding algorithm.
	 */
	public class Node
	{
		public var x:int;
		public var y:int;
		public var f:int;
		public var g:int;
		public var h:int;
		public var walkable:Boolean = true;
		public var parent:Node;
		public var costMultiplier:int = 10;
		
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
	}
}