package com.lhm3d.texturemanager
{
	
	import com.lhm3d.globals.Globals;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.geom.*;
	
	public class TextureManager
	{
		
		public static var textures:Vector.<TextureManagerEntity> = new Vector.<TextureManagerEntity>();
		
		public static var cubeTextures:Vector.<CubeTextureManagerEntity> = new Vector.<CubeTextureManagerEntity>();
		
		private static var dummyTexture:BitmapData;
		
		public static function init():void {
			
			createDummyTexture();
		}
		
		
		private static function createDummyTexture() : void  {
			var _cols:Vector.<uint> = new Vector.<uint>();
			_cols.push(0xff0000,0xffff00,0x00ffff,0xff00ff,0x00ff00,0x0000ff,0x77ff00,0xff0077,0x777777,0xffffff,0x7700ff,0xffee11,0x112233,0xaa22ee,0x000000);
			dummyTexture = new BitmapData(256,256,false,0x00ff00);
			var c:int = 0;
			for (var i:int = 0; i < 16; i++) {
				for (var o:int = 0; o < 16; o++) {
					dummyTexture.fillRect(new Rectangle(i*16,o*16,16,16),_cols[c%_cols.length]);
					c++;	
				}
			}
		}
		
		public static function getDummyTexture() : BitmapData { return dummyTexture; }
		
		
		public static function addTextureFromBMD(_bmd:BitmapData):int {
			
			textures.push(new TextureManagerEntity());
			
			textures[textures.length-1].texture = Globals.context3D.createTexture(_bmd.width, _bmd.height, Context3DTextureFormat.BGRA, false);
			textures[textures.length-1].texture.uploadFromBitmapData(_bmd);			
		
			return(textures.length-1);
		}
		
		
		public static function addCubeTextureFromBMD(_posX:BitmapData,_negX:BitmapData,_posY:BitmapData,_negY:BitmapData,_posZ:BitmapData,_negZ:BitmapData):int {
			
			cubeTextures.push(new CubeTextureManagerEntity());
			
			cubeTextures[cubeTextures.length-1].cubeTexture = Globals.context3D.createCubeTexture(_posX.width, Context3DTextureFormat.BGRA,false);
			genCubeMipMap(_posX,cubeTextures[cubeTextures.length-1].cubeTexture,0);
			genCubeMipMap(_negX,cubeTextures[cubeTextures.length-1].cubeTexture,1);
			genCubeMipMap(_posY,cubeTextures[cubeTextures.length-1].cubeTexture,2);
			genCubeMipMap(_negY,cubeTextures[cubeTextures.length-1].cubeTexture,3);
			genCubeMipMap(_posZ,cubeTextures[cubeTextures.length-1].cubeTexture,4);
			genCubeMipMap(_negZ,cubeTextures[cubeTextures.length-1].cubeTexture,5);
			
			return(cubeTextures.length-1);
			
		}
		
		
		private static function genCubeMipMap(_bmdTex:BitmapData, _cubeTexture:CubeTexture, _texSide:int):void{
			var _size:int = _bmdTex.width;
			
			var _mat:Matrix = new Matrix();
			var i:int = 0; 
			for (var _s:int = _size; _s> 0; _s>>=1) {
				var _scale:Number = _s / _size;
				_mat.identity();
				_mat.scale(_scale, _scale);
				var _bmd:BitmapData = new BitmapData(_s,_s,false);
				_bmd.draw(_bmdTex,_mat, null, null, null, true);
				_cubeTexture.uploadFromBitmapData(_bmd,_texSide,i);
				i++;
			}
			
		
		}
		
		
		private static function createCubeTexture(bitmap:BitmapData) : CubeTexture {
			var size:int = bitmap.width / 2, tex:CubeTexture = Globals.context3D.createCubeTexture(size, "bgra", false), 
				src:BitmapData, bmp:BitmapData, mat:Matrix = new Matrix(), i:int, mm:int, s:int, scl:Number, rot:Array=[-1,1,2,0,0,0];
			for (i=0; i<6; i++) {
				src = new BitmapData(size, size, false);
				src.copyPixels(bitmap, new Rectangle((i%3)*size, (int(i/3))*size, size, size), new Point(0, 0));
				for (mm=0, s=size; s!=0; mm++, s>>=1) {
					scl = s / size;
					mat.identity();
					mat.translate(size*-0.5,size*-0.5);
					mat.rotate(rot[i]*Math.PI*0.5);
					mat.translate(size*0.5,size*0.5);
					mat.scale(scl, scl);
					bmp = new BitmapData(s, s, false);
					bmp.draw(src, mat, null, null, null, true);
					tex.uploadFromBitmapData(bmp, i,mm);
					bmp.dispose();
				}
			}
			return tex;
		}
		
		
		
		
	}
}