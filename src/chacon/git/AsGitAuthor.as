package chacon.git
{
	public class AsGitAuthor
	{
		
		public var name:String;
		public var email:String;
		public var date:Date;
		
		public function AsGitAuthor(strAuthor:String):void
		{
			var author:Array = strAuthor.match(/(.*?) <(.*?)> (\d+) (.*)/)
			name = author[1];
			email = author[2];
			date = new Date();
			date.setTime(Number(author[3]) * 1000);  // convert from seconds to milliseconds
		}

	}
}