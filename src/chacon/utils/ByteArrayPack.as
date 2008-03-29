package chacon.utils
{
	import flash.utils.ByteArray;
	
	// ByteArray packing manipulations for use in creating Git bare objects
	// Author : Scott Chacon (schacon@gmail.com)
	
	public class ByteArrayPack
	{

		public static function isAlpha(n:uint):Boolean {
			if(n <= 102 && n >= 97) {
				return true;
			}
			return false;
		}
		
		// this will do the equivalent of array.pack('H*') in ruby
		// needed to pack an unencoded sha to write to git tree and commit objects
		public static function packHex(bytes:ByteArray):ByteArray
		{
			var hexArray:ByteArray = new ByteArray();
			var byte:int = 0;
			
			for (var i:uint = 1; i <= bytes.length; ++i) {
				var n:uint = bytes[i - 1];
				
				if(isAlpha(n)) {
					byte |= ((n & 15) + 9) & 15;
				} else {
                	byte |= (n & 15);
				}
				if(i & 1) {
					byte <<= 4;
				} else {
					hexArray.writeByte(byte & 0xff);
					byte = 0;
				}
			}
			
			return hexArray;
		}

		// this will do the equivalent of string.unpack('H*') in ruby
		// needed to unpack an encoded sha read from in git tree and commit objects
		public static function unpackHex(bytes:ByteArray):ByteArray
		{
			var hex:String = "0123456789abcdef";
			var chrArray:ByteArray = new ByteArray();
			
			for (var i:uint = 0; i < bytes.length; ++i) {					
				var n:uint = bytes[i];
				chrArray.writeMultiByte(hex.charAt((n >> 4) & 15), 'iso-8859-1');
				n <<= 4;
				chrArray.writeMultiByte(hex.charAt((n >> 4) & 15), 'iso-8859-1');
			}
			
			return chrArray;
		}

	}
}